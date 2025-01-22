//
//  LoadTracksPresenter.swift
//  MP3_Player
//
//  Created by Databriz on 17/01/2025.
//

import Foundation
import UIKit


struct Track {
    let nameTrack: String
    let nameAuthor: String
}


class LoadTracksPresenter{
    
    var wasLoad: (([MusicItems])->Void)?
    
    private var view: LoadTracksView?
    private var musicItems: [MusicItems]?
    private var tracks: [Track]?
    
    init(view: LoadTracksView) {
        self.view = view
    }
    
    func startLoadTracks(){
        guard let musics = loadFromCoreDataItems(), musics.count > 0 else {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                loadTracks(from: documentsDirectory){ tracks in
                    self.tracks = tracks
                    self.saveToCoreDataFiles()
                }
                startLoadTracks()
            }
            return
        }
        print("CoreData заполнена")
        loadFinish(musics: musics)
    }
    
    func loadFinish(musics: [MusicItems]){
        creatPlayList(musicItems: musics)
        wasLoad!(musics)
    }
    
    func loadFromCoreDataItems() -> [MusicItems]?{
        let coreDataManager = CoreDataManager.shared
        guard let musicItems = coreDataManager.fetchMusics(), !musicItems.isEmpty else {
            return []
        }
        return musicItems
    }
    
    func creatPlayList(musicItems: [MusicItems]?){
        let avPlayer = AVPlayerManager.shared
        var playList: [Int16: URL] = [:]
        
        for item in musicItems ?? [] {
            if let musicURLString = item.musicURL{
                let musicURL = URL(fileURLWithPath: musicURLString)
                if FileManager.default.fileExists(atPath: musicURL.path) {
                    print("Файл существует по пути: \(musicURL.path)")
                    playList[item.id] = musicURL
                    print("Добавлена в плейлист композиция: \(item.musicName ?? "Неизветсная") от \(item.author ?? "Неизветсного")")
                } else {
                    print("Файл не существует по пути: \(musicURL.path)")
                }
            }else{
                print("URL трека nil")
            }
        }
        avPlayer.creatPlayList(playList: playList)
    }
    
    func saveToCoreDataFiles() {
        let coreDataManager = CoreDataManager.shared
        for (index, track) in (tracks ?? []).enumerated() {
            let fileName = "\(track.nameTrack) - \(track.nameAuthor)"
            print("Ищем файл: \(fileName).mp3")

            let resourcePaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
            if resourcePaths.isEmpty {
                print("Нет доступных mp3 файлов")
            } else {
                print("Доступные mp3 файлы: \(resourcePaths)")
            }

            // Поиск файла
            guard let path = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Musics") else {
                print("Аудиофайл '\(fileName).mp3' не найден")
                return
            }

            print("Файл найден: \(path)")

            let urlString = path.path // Сохраняем только путь к файлу

            coreDataManager.createMusic(
                id: Int16(index + 1),
                musicURL: urlString,
                author: track.nameAuthor,
                musicName: track.nameTrack,
                coverImage: UIImage(named: "Cover \(index + 1)")?.pngData()
            )
        }
    }
    
    func getAudioFilesFromBundle() -> [URL]? {
        // Получаем путь к папке musics в Bundle
        if let bundlePath = Bundle.main.resourceURL?.appendingPathComponent("Musics") {
            let fileManager = FileManager.default
            
            do {
                // Получаем список файлов в папке musics
                let files = try fileManager.contentsOfDirectory(at: bundlePath, includingPropertiesForKeys: nil, options: [])
                
                // Фильтруем только аудиофайлы (например, .mp3, .m4a)
                let audioFiles = files.filter { file in
                    let fileExtension = file.pathExtension.lowercased()
                    return fileExtension == "mp3" || fileExtension == "m4a" // Добавьте другие расширения, если нужно
                }
                
                return audioFiles
            } catch {
                print("Ошибка при чтении папки Musics: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Папка musics не найдена в Bundle.")
            return nil
        }
    }
    
    func loadTracks(from directory: URL, completion: @escaping ([Track]?) -> Void){
        var tracks: [Track] = []
            
            // Получаем список аудиофайлов из папки musics
        guard let audioFiles = getAudioFilesFromBundle() else {
            completion(nil)
            return
        }
            
            // Обрабатываем каждый файл
            for fileURL in audioFiles {
                let fileName = fileURL.deletingPathExtension().lastPathComponent
                
                // Извлекаем nameTrack и nameAuthor из имени файла
                if let trackInfo = parseTrackInfo(from: fileName) {
                    let track = Track(
                        nameTrack: trackInfo.nameTrack,
                        nameAuthor: trackInfo.nameAuthor)
                    tracks.append(track)
                }
            }
            completion(tracks)
    }
    
    func parseTrackInfo(from fileName: String) -> (nameTrack: String, nameAuthor: String)? {
        let components = fileName.components(separatedBy: " - ")
           
           guard components.count == 2 else {
               print("Некорректный формат имени файла: \(fileName)")
               return nil
           }
           
           let nameTrack = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
           let nameAuthor = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
           
           return (nameTrack, nameAuthor)
    }
   
}

private extension LoadTracksPresenter {
    enum Const {
        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
    }
}

