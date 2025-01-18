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
    // Синглтон
    public static let shared = AVPlayerManager()
    
    private var idTrack: Int16?
    
    // Приватный инициализатор
    private override init() {
        super.init() // Вызов инициализатора родительского класса
    }

    // Метод для воспроизведения трека по URL
    func startTrack(url: URL, idTrack: Int16) {
        self.pause()
        let newPlayerItem = AVPlayerItem(url: url)
        self.replaceCurrentItem(with: newPlayerItem)
        self.idTrack = idTrack
        self.play()
    }
    
    func getIdTrack() -> Int16?{
        return self.idTrack
    }
    
    func isPlaying() -> Bool{
        return self.rate != 0
    }
}
