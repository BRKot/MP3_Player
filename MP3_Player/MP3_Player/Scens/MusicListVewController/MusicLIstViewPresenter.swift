//
//  MusicLIstViewPresenter.swift
//  MP3_Player
//
//  Created by Databriz on 17/01/2025.
//

import Foundation
import UIKit
import AVFoundation

class MusicLIstPresenter{
    private var view: PlayerView?
    
    init(view: PlayerView) {
        self.view = view

    }

   
}

private extension MusicLIstPresenter {
    enum Const {
        static let playButton = UIImage(systemName: "play.fill") ?? UIImage()
        static let pauseButton = UIImage(systemName: "pause.fill") ?? UIImage()
    }
}
