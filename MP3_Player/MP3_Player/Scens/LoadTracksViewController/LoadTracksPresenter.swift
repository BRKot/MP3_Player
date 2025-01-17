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
    let fileURL: URL // URL файла для дальнейшего использования
}


class LoadTracksPresenter{
    private var view: LoadTracksView?
    private var musicItems: [MusicItems]?
    private var tracks: [Track]?
    
    init(view: LoadTracksView) {
        self.view = view
        
        if coreDataIsExist(){
            CoreDataManager.shared.deletAllMusicItems()
            print("CoreData заполнена")
        }else{
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                self.tracks = loadTracks(from: documentsDirectory)
                
                for track in self.tracks ?? [] {
                    print("Трек: \(track.nameTrack), Автор: \(track.nameAuthor), URL: \(track.fileURL)")
                }
            }
        }
    }
    
    func coreDataIsExist() -> Bool{
        let coreDataManager = CoreDataManager.shared
        
        return coreDataManager.fetchMusics() != []
    }
    
    func saveToCoreDataFiles(){
        let coreDataManager = CoreDataManager.shared
        for (index, track) in (tracks ?? []).enumerated(){
            coreDataManager.createMusic(id: Int16(index),
                                        musicURL: track.fileURL.path(),
                                        author: track.nameAuthor,
                                        musicName: track.nameTrack,
                                        coverImage: UIImage(named: "Cover \(index)")?.pngData())
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
    
//    func getAudioFiles(from directory: URL) -> [URL]? {
//        let fileManager = FileManager.default
//        
//        do {
//            // Получаем список всех файлов в папке
//            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
//            
//            // Фильтруем только аудиофайлы (например, .mp3, .m4a)
//            let audioFiles = files.filter { file in
//                let fileExtension = file.pathExtension.lowercased()
//                return fileExtension == "mp3"
//            }
//            
//            return audioFiles
//        } catch {
//            print("Ошибка при чтении папки: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    func loadTracks(from directory: URL) -> [Track] {
        var tracks: [Track] = []
            
            // Получаем список аудиофайлов из папки musics
            guard let audioFiles = getAudioFilesFromBundle() else {
                return tracks
            }
            
            // Обрабатываем каждый файл
            for fileURL in audioFiles {
                let fileName = fileURL.deletingPathExtension().lastPathComponent
                
                // Извлекаем nameTrack и nameAuthor из имени файла
                if let trackInfo = parseTrackInfo(from: fileName) {
                    let track = Track(
                        nameTrack: trackInfo.nameTrack,
                        nameAuthor: trackInfo.nameAuthor,
                        fileURL: fileURL
                    )
                    tracks.append(track)
                }
            }
            
            return tracks
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

