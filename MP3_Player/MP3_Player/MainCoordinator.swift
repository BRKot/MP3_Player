//
//  MainCoordinator.swift
//  MP3_Player
//
//  Created by Databriz on 17/01/2025.
//

import UIKit

protocol Coordinator {
    func start()
}

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoadView()
    }
    
    func showLoadView() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadTracksViewController") as? LoadTracksViewController else {
            return
        }
        let presenter = LoadTracksPresenter(view: viewController)
        viewController.presenter = presenter
      
        presenter.wasLoad = { musicItems in
            self.showTrackListView(musicItems: musicItems)
        }
        
        navigationController.pushViewController(viewController, animated: true)
        presenter.startLoadTracks()
    }
    
    func showTrackListView(musicItems: [MusicItems]) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicLIstViewController") as? MusicLIstViewController else {
            return
        }
        
        let presenter = MusicLIstPresenter(view: viewController, musicItems: musicItems)
        
        viewController.presenter = presenter
        
        
        presenter.onselectedCell = { musicItems, musicId in
            self.showPlayerView(musicItems: musicItems, musicId: musicId)
        }
        
        navigationController.pushViewController(viewController, animated: true)
        self.navigationController.isNavigationBarHidden = true
    }
    
    func showPlayerView(musicItems: [MusicItems], musicId: Int16) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        let presenter = PlayerViewPresenter(view: viewController, idPlayTrack: musicId, musicItems: musicItems)
        
        viewController.presenter = presenter
        
        viewController.modalTransitionStyle = .coverVertical // Анимация снизу вверх
        
        
        presenter.closeView = {
            self.navigationController.dismiss(animated:true)
        }
        
        navigationController.present(viewController, animated: true)
    }
}
