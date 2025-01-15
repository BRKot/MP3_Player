//
//  PlayerViewPresenter.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import Foundation
import UIKit
import AVFoundation

class PlayerViewPresenter{
    

    private var view: PlayerView?
    var timeObserver: Any?
    var audioPlayer: AVPlayer?
    var newTrack = true
    var isPlaing: Bool = false {
        didSet{
            tupOnPlayButton()
        }
    }
    
    init(view: PlayerView){
        self.view = view
    }
    
    func setupUI(){
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
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)) // Обновление каждые 0.1 секунды
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            // Обновляем значение слайдера
            let duration = self.audioPlayer?.currentItem?.duration.seconds ?? 0
            let currentTime = time.seconds
            DispatchQueue.main.async {
                self.view?.configurTrackTimeSlider(value: Float(currentTime / duration))
                print(currentTime)
            }
        }
    }
    
    
    func tupOnPlayButton(){
        
        if isPlaing{
            if newTrack{
                guard let path = Bundle.main.path(forResource: "Metel", ofType: "mp3") else {
                    print("Аудиофайл не найден")
                    return
                }
                let url = URL(fileURLWithPath: path)
                audioPlayer = AVPlayer(url: url)
                newTrack = false
                addTimeObserver()
            }
            audioPlayer?.play()
            print(audioPlayer?.currentItem?.duration)
            
            view?.configurPlayTrackButton(image: Const.pauseButton)
        }else{
            audioPlayer?.pause()
            view?.configurPlayTrackButton(image: Const.playButton)
        }
        
    }
    
    func changeTrackTime(partFullTime: Double){
        guard let duration = audioPlayer?.currentItem?.duration.seconds else { return }
                
                let newTime = partFullTime * duration
                let seekTime = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                audioPlayer?.seek(to: seekTime)
    }
}

private extension PlayerViewPresenter{
    enum Const{
        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
    }
}
