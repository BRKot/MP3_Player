import Foundation
import UIKit
import AVFoundation

class PlayerViewPresenter {
    private var view: PlayerView?
    var timeObserver: Any?
    var audioPlayer: AVPlayer?
    var newTrack = true
    var musics: [MusicItems] = []
    
    var indexMass: Int? {
        didSet{
            if (indexMass ?? 1) > musics.count{
                indexMass = 1
            }
            
            if (indexMass ?? 1) < 1{
                indexMass = musics.count
            }
            setImage()
            playTrack()
        }
    }
    
    var isPlaing: Bool = true {
        didSet {
            // Обработка изменения состояния воспроизведения
        }
    }

    init(view: PlayerView) {
        self.view = view
        indexMass = 1
//        addMusicToCoreData()
        getAllMusicsFromCoreData()
    }

    func addMusicToCoreData() {
//        let coreData = CoreDataManager.shared
//
//        // Добавление первого трека
//        guard let path = Bundle.main.url(forResource: "Metel", withExtension: "mp3") else {
//            print("Аудиофайл 'Metel.mp3' не найден")
//            return
//        }
//        let urlString = path.path // Сохраняем только путь к файлу
//
//        coreData.createMusic(
//            id: 1,
//            musicURL: urlString,
//            author: "DDT",
//            musicName: "Metel",
//            coverImage: UIImage(named: "Cover 1")?.pngData()
//        )
//
//        // Добавление второго трека
//        guard let path2 = Bundle.main.url(forResource: "ZnaeshLiTi", withExtension: "mp3") else {
//            print("Аудиофайл 'ZnaeshLiTi.mp3' не найден")
//            return
//        }
//        let urlString2 = path2.path // Сохраняем только путь к файлу
//
//        coreData.createMusic(
//            id: 2,
//            musicURL: urlString2,
//            author: "Maksim",
//            musicName: "ZnaeshLiTi",
//            coverImage: UIImage(named: "Cover 1")?.pngData()
//        )
//        
//        guard let path3 = Bundle.main.url(forResource: "Ссора", withExtension: "mp3") else {
//            print("Аудиофайл 'Ссора.mp3' не найден")
//            return
//        }
//        let urlString3 = path3.path // Сохраняем только путь к файлу
//
//        coreData.createMusic(
//            id: 3,
//            musicURL: urlString3,
//            author: "Дима Бамберг",
//            musicName: "Ссора",
//            coverImage: UIImage(named: "Cover 3")?.pngData()
//        )
    }

    func getAllMusicsFromCoreData(){
        let coreDataManager = CoreDataManager.shared
        
        guard let musics = coreDataManager.fetchMusics() else{
            print("Не нашлась музыка")
            return
        }
        
        self.musics = musics
    }
    
    func playTrack(){
        let coreData = CoreDataManager.shared
        
        guard let music = musics.first(where: {indexMass ?? 1 == $0.id}) else {
            print("Музыка с ID 1 не найдена")
            return
        }
        
        if let musicURLString = music.musicURL {
            let musicURL = URL(fileURLWithPath: musicURLString)

            // Проверка существования файла
            if FileManager.default.fileExists(atPath: musicURL.path) {
                print("Файл существует по пути: \(musicURL.path)")

                // Настройка аудиосессии
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Ошибка настройки аудиосессии: \(error)")
                }

                // Воспроизведение аудио
                audioPlayer = AVPlayer(url: musicURL)
                
                DispatchQueue.main.async {
                    self.addTimeObserver()
                    self.audioPlayer?.play()
                }
            } else {
                print("Файл не существует по пути: \(musicURL.path)")
            }
        } else {
            print("Некорректный URL")
        }
    }
    
    func setImage(){
        print("Cover \(Int(indexMass ?? 1))")
        guard let image = UIImage(named: "Cover \(Int(indexMass ?? 1))") else {
            print("Не нашлась картинка")
            return
        }
        DispatchQueue.main.async{
            self.view?.configurCoverImageView(image: image)
        }
    }

    func setupUI() {
        guard let playIcon = UIImage(systemName: "play.fill") else {
            print("Иконка не найдена")
            return
        }
        print("Иконка загружена: \(playIcon)")
        self.view?.configurPlayTrackButton(image: playIcon)
        self.view?.configurCoverImageView(image: UIImage(named: "Cover \(Int.random(in: 1...9))") ?? UIImage())
        self.view?.configurTrackTimeSlider(value: 0)
    }

    func addTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            let duration = self.audioPlayer?.currentItem?.duration.seconds ?? 0
            let currentTime = time.seconds
            DispatchQueue.main.async {
                self.view?.configurTrackTimeSlider(value: Float(currentTime / duration))
            }
        }
    }

    func changeTrackTime(partFullTime: Double) {
        guard let duration = audioPlayer?.currentItem?.duration.seconds else { return }
        let newTime = partFullTime * duration
        let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        audioPlayer?.seek(to: seekTime)
    }
}

private extension PlayerViewPresenter {
    enum Const {
        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
    }
}

////
////  PlayerViewPresenter.swift
////  MP3_Player
////
////  Created by Databriz on 15/01/2025.
////
//
//import Foundation
//import UIKit
//import AVFoundation
//
//class PlayerViewPresenter{
//    
//
//    private var view: PlayerView?
//    var timeObserver: Any?
//    var audioPlayer: AVPlayer?
//    var newTrack = true
//    var isPlaing: Bool = true {
//        didSet{
////            tupOnPlayButton(url: URL(fileURLWithPath: ""))
//        }
//    }
//    
//    init(view: PlayerView){
//        self.view = view
//        addMusicToCoreData()
//    }
//    
//    func addMusicToCoreData(){
//        let coreData = CoreDataManager.shared
//        guard let path = Bundle.main.url(forResource: "Metel", withExtension: "mp3") else {
//            print("Аудиофайл не найден")
//            return
//        }
//        let urlString = path.path
//        
//        coreData.createMusic(id: 1,
//                             musicURL: urlString,
//                             author: "DDT",
//                             musicName: "Metel",
//                             coverImage: UIImage(named: "Cover 1")?.pngData())
//        
//        guard let path2 = Bundle.main.url(forResource: "ZnaeshLiTi", withExtension: "mp3") else {
//            print("Аудиофайл не найден")
//            return
//        }
//        let urlString2 = path2.path
//        
//        coreData.createMusic(id: 2,
//                             musicURL: urlString2,
//                             author: "Maksim",
//                             musicName: "ZnaeshLiTi",
//                             coverImage: UIImage(named: "Cover 1")?.pngData())
//    }
//    
//    func getMusicFromCoreData(){
//        let coreData = CoreDataManager.shared
//        
//        let music = coreData.fetchMusic(with: 1)
//        
//        if let url = URL(string: music?.musicURL ?? ""){
//            audioPlayer = AVPlayer(url: url)
//            addTimeObserver()
//            DispatchQueue.main.async {
//                self.audioPlayer?.play()
//            }
//            
//        }else{
//            print("Не найден файл после CorData")
//        }
//    }
//    
//    func setupUI(){
//        guard let playIcon = UIImage(systemName: "play.fill") else {
//            print("Иконка не найдена")
//            return
//        }
//        print("Иконка загружена: \(playIcon)")
//        self.view?.configurPlayTrackButton(image: playIcon)
//        self.view?.configurCoverImageView(image: UIImage(named: "Cover \(Int.random(in: 1...9))") ?? UIImage())
//        self.view?.configurTrackTimeSlider(value: 0)
//    }
//    
//    func addTimeObserver() {
//        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)) // Обновление каждые 0.1 секунды
//        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
//            guard let self = self else { return }
//            
//            // Обновляем значение слайдера
//            let duration = self.audioPlayer?.currentItem?.duration.seconds ?? 0
//            let currentTime = time.seconds
//            DispatchQueue.main.async {
//                self.view?.configurTrackTimeSlider(value: Float(currentTime / duration))
//                print(currentTime)
//            }
//        }
//    }
//    
//    
////    func tupOnPlayButton(url: URL){
////        
////        if isPlaing{
////            if newTrack{
////                guard let path = Bundle.main.path(forResource: "Metel", ofType: "mp3") else {
////                    print("Аудиофайл не найден")
////                    return
////                }
////                let url = URL(fileURLWithPath: path)
////                audioPlayer = AVPlayer(url: url)
////                newTrack = false
////                addTimeObserver()
////            }
////            audioPlayer?.play()
////            print(audioPlayer?.currentItem?.duration)
////            
////            view?.configurPlayTrackButton(image: Const.pauseButton)
////        }else{
////            audioPlayer?.pause()
////            view?.configurPlayTrackButton(image: Const.playButton)
////        }
////        
////    }
//    
//    func changeTrackTime(partFullTime: Double){
//        guard let duration = audioPlayer?.currentItem?.duration.seconds else { return }
//                
//                let newTime = partFullTime * duration
//                let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//                audioPlayer?.seek(to: seekTime)
//    }
//}
//
//private extension PlayerViewPresenter{
//    enum Const{
//        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
//        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
//    }
//}
