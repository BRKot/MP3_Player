//
//  AVPlayerManager.swift
//  MP3_Player
//
//  Created by Databriz on 18/01/2025.
//

import UIKit
import AVFoundation

// MARK: - CRUD

public final class AVPlayerManager: AVPlayer {
    
    private var nextTrackHandlers = [(Int16) -> Void]()
    
    // Синглтон
    public static let shared = AVPlayerManager()
    
    private var idCurrentTrack: Int16 = 0{
        didSet {
            // Проверяем, что массив не пуст
            guard let keys = playList?.keys, !keys.isEmpty else {
                return
            }
            // Находим минимальное и максимальное значение id в массиве
            let minId = keys.min(by: { $0 < $1 }) ?? 0
            let maxId = keys.max(by: { $0 < $1 }) ?? 0

            // Ограничиваем значение idPLayTrack в пределах minId и maxId
            if idCurrentTrack > maxId {
                idCurrentTrack = minId
            } else if idCurrentTrack < minId {
                idCurrentTrack = maxId
            }
            self.replaceCurrentItemById(with: idCurrentTrack)
            nextTrackHandlers.forEach { $0(idCurrentTrack) }
        }
    }
    
    public var playList: [Int16: URL]?
    
    // Приватный инициализатор
    private override init() {
        super.init() // Вызов инициализатора родительского класса
        configureNotificationPlayer()
    }
    
    func getIdTrack() -> Int16?{
        return self.idCurrentTrack
    }
    
    func isPlaying() -> Bool{
        return self.rate != 0
    }
    
    
    // MARK: Заполняем плелист для фоновой работы в списке треков
    
    ////настрйока оповещения о том что трек закончился
    func configureNotificationPlayer(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: self.currentItem
        )
    }
    
    public func addNextTrackHandler(_ handler: @escaping (Int16) -> Void) {
        nextTrackHandlers.append(handler)
    }
    ///
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.idCurrentTrack += 1
        self.play()
    }
    
    func creatPlayList(playList: [Int16: URL]){
        self.playList = playList
    }
    
    func replaceCurrentItemById(with id: Int16) {
        guard let playList = self.playList, !playList.isEmpty else {
            print("Плелист пуст")
            return
        }
        
        guard let trackURL = playList[id] else {
            print("Трек с ID \(id) не найден в плейлисте")
            return
        }
        
        let avPlayerItem = AVPlayerItem(url: trackURL)
        
        self.replaceCurrentItem(with: avPlayerItem)
    }
    
    func playTrack(id: Int16){
        guard let url = self.playList?[id] else {
            print("Трекс с ID \(id) не найден")
            return
        }
        
        self.volume = 0.1
        
        let newPlayerItem = AVPlayerItem(url: url)
        self.replaceCurrentItem(with: newPlayerItem)
        self.idCurrentTrack = id
        self.play()
    }
    
    func playNextTrack(){
        self.idCurrentTrack += 1
    }
    
    func playBackTrack(){
        self.idCurrentTrack -= 1
    }
    
    func getPartTrack() -> Float{
        guard let currentTime = self.currentItem?.currentTime(), let duration = self.currentItem?.duration else {
            return 0
        }
        let seconds = CMTimeGetSeconds(currentTime)
        let secondsDuration = CMTimeGetSeconds(duration)
        
        return Float(seconds) / Float(secondsDuration)
    }
    
    func trackIsStarted() -> Bool{
        return self.getPartTrack() > 0
    }
    
}
