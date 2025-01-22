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
    
    var onselectedCell:(([MusicItems], Int16)->Void)?
    
    weak private var view: MusicLIstView?
    private var musicItems: [MusicItems]
    private var avPlayerManager: AVPlayerManager?
    
    var numberCells: Int{
        return musicItems.count
    }
    
    var reuseIdentifier: String{
        return Const.reuseIdentifier
    }
    
    init(view: MusicLIstView,
         musicItems: [MusicItems],
         avPlayerManager: AVPlayerManager = AVPlayerManager.shared) {
        self.view = view
        self.musicItems = musicItems
        self.avPlayerManager = avPlayerManager
    }

    func setupUI(){
        self.view?.setupTableView(reusIdentifier: Const.reuseIdentifier)
        self.avPlayerManager?.addNextTrackHandler { [weak self] id in
            print("В окне списка \(id)")
        }
    }
    
    func getEqualMusicItem(index: Int) -> MusicItems?{
        if index > musicItems.count{ return nil }
        return musicItems[index]
    }
    
    func selectMusic(id: Int16){
        if self.avPlayerManager?.isPlaying() ?? false{
            if self.avPlayerManager?.getIdTrack() == id{
                self.avPlayerManager?.play()
            }else{
                self.avPlayerManager?.playTrack(id: id)
            }
        }else{
            if self.avPlayerManager?.getIdTrack() == id{
                
            }else{
                self.avPlayerManager?.playTrack(id: id)
            }
        }
        onselectedCell!(self.musicItems, id)
    }
}

private extension MusicLIstPresenter {
    enum Const {
        static let reuseIdentifier = "TrackTableViewCell"
    }
}
