import Foundation
import UIKit
import AVFoundation

class PlayerViewPresenter {
    
    var closeView: (()->Void)?
    
    weak private var view: PlayerView?
    unowned var avPlayerManager: AVPlayerManager
    
    var timeObserver: Any?
    var musicsItems: [MusicItems] = []
    
    
    var isSliding = false
    
    init(view: PlayerView,
         musicItems: [MusicItems],
         avPlayerManager: AVPlayerManager = AVPlayerManager.shared) {
        self.view = view
        self.musicsItems = musicItems
        self.avPlayerManager = avPlayerManager
    }
    
    func onCloseView(){
        closeView!()
    }
    
    func setupUI() {
        
        guard let music =  getCurrentTrackItem()else{
            return
        }
        
        avPlayerManager.addNextTrackHandler { [weak self] id in
            self?.setupUIForNextTrack(idNewTrack: id)
        }
        
        self.view?.addTrackTimeSliderTargets()
        self.view?.configureSwaps()
        self.view?.configurCoverImageView(image: UIImage(data: music.coverImage ?? Data()) ?? UIImage())
        self.view?.configurAuthorNameLabel(atributs: NSAttributedString(string: music.author ?? "",
                                                                        attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurTrackNameLabel(atributs: NSAttributedString(string: music.musicName ?? "",
                                                                       attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurPlayTrackButton(image: avPlayerManager.isPlaying() ? Const.pauseButton : Const.playButton)
        self.view?.configurTrackBackButton(image: Const.backButton)
        self.view?.configurTrackForwardButton(image: Const.nextButton)
        
        self.view?.configurTrackTimeSlider(value: avPlayerManager.getPartTrack())
        
        addTimeObserver()
        setUpTrackTime()
    }
    
    func setupUIForNextTrack(idNewTrack: Int16){
        guard let music = musicsItems.first(where: {$0.id == idNewTrack}) else{
            return
        }
        avPlayerManager.play()
        self.view?.configurCoverImageView(image: UIImage(data: music.coverImage ?? Data()) ?? UIImage())
        self.view?.configurAuthorNameLabel(atributs: NSAttributedString(string: music.author ?? "",
                                                                        attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurTrackNameLabel(atributs: NSAttributedString(string: music.musicName ?? "",
                                                                       attributes: [.foregroundColor: UIColor.white]))
        self.view?.configurPlayTrackButton(image: avPlayerManager.isPlaying() ? Const.pauseButton : Const.playButton)
    }
    
    func getCurrentTrackItem()->MusicItems?{
        let musicItem = self.musicsItems.first(where: {self.avPlayerManager.getIdTrack() == $0.id  })
        
        return musicItem
    }
    
    func tupOnPlayOrStopButton(){
        if avPlayerManager.isPlaying(){
            pauseTrack()
        }else{
            playTrack()
        }
    }
    
    func playTrack() {
        self.avPlayerManager.play()
        self.view?.configurPlayTrackButton(image: Const.pauseButton)
    }
    
    func pauseTrack(){
        self.avPlayerManager.pause()
        self.view?.configurPlayTrackButton(image: Const.playButton)
    }
    
    func playNextTrack(){
        self.avPlayerManager.playNextTrack()
    }
    
    func playBackTrack(){
        self.avPlayerManager.playBackTrack()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = self.avPlayerManager.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, !self.isSliding else { return }
            let duration = self.avPlayerManager.currentItem?.duration.seconds ?? 0
            let currentTime = time.seconds
            DispatchQueue.main.async {
                self.view?.configurTrackTimeSlider(value: Float(currentTime / duration))
            }
        }
    }
    
    func changeTrackTime(partFullTime: Double) {
        guard let duration = avPlayerManager.currentItem?.duration.seconds else { return }
        let newTime = partFullTime * duration
        let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        avPlayerManager.seek(to: seekTime)
    }
    
    func setUpTrackTime(){
        if avPlayerManager.currentItem != nil {
            let currentTime = avPlayerManager.currentTime()
            let currentSeconds = CMTimeGetSeconds(currentTime) // Конвертируем CMTime в секунды
            let duration = self.avPlayerManager.currentItem?.duration.seconds ?? 0
            self.view?.configurTrackTimeSlider(value: Float(currentSeconds / duration))
        }
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
