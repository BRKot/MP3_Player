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
    
    private var view: MusicLIstView?
    private var musicItems: [MusicItems]
    
    var numberCells: Int{
        return musicItems.count
    }
    
    var reuseIdentifier: String{
        return Const.reuseIdentifier
    }
    
    init(view: MusicLIstView,
         musicItems: [MusicItems]) {
        self.view = view
        self.musicItems = musicItems
    }

    func setupUI(){
        self.view?.setupTableView(reusIdentifier: Const.reuseIdentifier)
    }
    
    func getEqualMusicItem(index: Int) -> MusicItems?{
        if index > musicItems.count{ return nil }
        return musicItems[index]
    }
    
    func selectMusic(id: Int16){
        onselectedCell!(self.musicItems, id)
    }
}

private extension MusicLIstPresenter {
    enum Const {
        static let reuseIdentifier = "TrackTableViewCell"
    }
}
