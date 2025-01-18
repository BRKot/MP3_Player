import Foundation
import UIKit
import AVFoundation

class PlayerViewPresenter {
    
    var closeView: (()->Void)?
    var isSliding = false
    private var view: PlayerView?
    var timeObserver: Any?
    var avPlayerManager: AVPlayerManager?
    
    var musicsItems: [MusicItems] = []
    var idPLayTrack: Int16 {
        didSet {
            // Проверяем, что массив не пуст
            guard !musicsItems.isEmpty else {
                return
            }
            // Находим минимальное и максимальное значение id в массиве
            let minId = musicsItems.min(by: { $0.id < $1.id })?.id ?? 0
            let maxId = musicsItems.max(by: { $0.id < $1.id })?.id ?? 0

            // Ограничиваем значение idPLayTrack в пределах minId и maxId
            if idPLayTrack > maxId {
                idPLayTrack = minId
            } else if idPLayTrack < minId {
                idPLayTrack = maxId
            }
            playNextTrack()
        }
    }
    
    var isPLaying: Bool = true{
        didSet {
            self.isPLaying ? playTrack() : pauseTrack()
        }
    }

    init(view: PlayerView,
         idPlayTrack: Int16,
         musicItems: [MusicItems],
         avPlayerManager: AVPlayerManager = AVPlayerManager.shared) {
        self.view = view
        self.idPLayTrack = idPlayTrack
        self.musicsItems = musicItems
        self.avPlayerManager = avPlayerManager
        
    }
    
    func onCloseView(){
        closeView!()
    }
    
    func setupUI() {
        
        self.view?.addTrackTimeSliderTargets()
        
        guard let music = musicsItems.first(where: {self.avPlayerManager?.getIdTrack() ?? self.idPLayTrack == $0.id}), let avPlayermanager = self.avPlayerManager else { return }
        self.view?.configurCoverImageView(image: UIImage(data: music.coverImage ?? Data()) ?? UIImage())
        self.view?.configurAuthorNameLabel(atributs: NSAttributedString(string: music.author ?? "",
                                                                attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurTrackNameLabel(atributs: NSAttributedString(string: music.musicName ?? "",
                                                                attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurPlayTrackButton(image: avPlayermanager.isPlaying() ? Const.pauseButton : Const.playButton)
        self.view?.configurTrackBackButton(image: Const.backButton)
        self.view?.configurTrackForwardButton(image: Const.nextButton)
        
        self.view?.configurTrackTimeSlider(value: 0)
        configureNotificationPlayer()
        addTimeObserver()
        setUpTrackTime()
        
    }
    
    func configureNotificationPlayer(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: avPlayerManager?.currentItem
        )
    }

    func pauseTrack(){
        self.avPlayerManager?.pause()
        self.view?.configurPlayTrackButton(image: Const.playButton)
    }
    
    func playNextTrack(){
        self.avPlayerManager?.pause()
        self.avPlayerManager?.replaceCurrentItem(with: nil)
        playTrack()
    }
    
    func playTrack() {
        
        if self.avPlayerManager?.currentItem != nil && self.idPLayTrack == self.avPlayerManager?.getIdTrack() {
            self.avPlayerManager?.play()
        }else{
            
            guard let music = musicsItems.first(where: { self.idPLayTrack == $0.id }) else {
                print("Музыка с ID \(idPLayTrack) не найдена")
                return
            }
            
            // Проверяем, что musicURL существует
            guard let musicURLString = music.musicURL else {
                print("URL трека nil")
                return
            }
            
            // Преобразуем строку в URL
            let musicURL = URL(fileURLWithPath: musicURLString)
            
            // Проверяем существование файла
            if FileManager.default.fileExists(atPath: musicURL.path) {
                print("Файл существует по пути: \(musicURL.path)")
                self.avPlayerManager?.startTrack(url: musicURL, idTrack: self.idPLayTrack)
                print("Играет композиция: \(music.musicName ?? "Неизветсная") от \(music.author ?? "Неизветсного")")
            } else {
                print("Файл не существует по пути: \(musicURL.path)")
            }
        }
        
        setupUI()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = self.avPlayerManager?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, !self.isSliding else { return }
            let duration = self.avPlayerManager?.currentItem?.duration.seconds ?? 0
            let currentTime = time.seconds
            DispatchQueue.main.async {
                self.view?.configurTrackTimeSlider(value: Float(currentTime / duration))
            }
        }
    }

    func changeTrackTime(partFullTime: Double) {
        guard let duration = avPlayerManager?.currentItem?.duration.seconds else { return }
        let newTime = partFullTime * duration
        let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        avPlayerManager?.seek(to: seekTime)
    }
    
    func setUpTrackTime(){
        if avPlayerManager?.currentItem != nil {
            if let currentTime = avPlayerManager?.currentTime() {
                let currentSeconds = CMTimeGetSeconds(currentTime) // Конвертируем CMTime в секунды
                let duration = self.avPlayerManager?.currentItem?.duration.seconds ?? 0
                self.view?.configurTrackTimeSlider(value: Float(currentSeconds / duration))
            } else {
                print("Текущая позиция недоступна.")
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.idPLayTrack += 1
    }
}

private extension PlayerViewPresenter {
    enum Const {
        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
        static let backButton = UIImage(systemName: "backward.end") ?? UIImage()
        static let nextButton = UIImage(systemName: "forward.end") ?? UIImage()
    }
}
