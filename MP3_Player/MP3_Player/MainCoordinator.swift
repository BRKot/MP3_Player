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
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = UIColor.white
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupBackButton(for viewController: UIViewController) {
        let backImage = UIImage(named: "BackIcone")
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(backImage, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 210)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: backButton)

        viewController.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backButtonPressed() {
        self.navigationController.popViewController(animated: true)
    }
    
    func start() {
        showLoadCiew()
    }
    
    func showLoadCiew() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadTracksViewController") as! LoadTracksViewController
        let presenter = LoadTracksPresenter(view: viewController)
        viewController.presenter = presenter
      
        presenter.wasLoad = { musicItems in
            self.showTrackListView(musicItems: musicItems)
        }
        
        navigationController.pushViewController(viewController, animated: true)
        presenter.loadTracks()
    }
    
    func showTrackListView(musicItems: [MusicItems]) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicLIstViewController") as! MusicLIstViewController
        
        let presenter = MusicLIstPresenter(view: viewController, musicItems: musicItems)
        
        viewController.presenter = presenter
        
        
        presenter.onselectedCell = { musicItems, musicId in
            self.showPlayerView(musicItems: musicItems, musicId: musicId)
        }
        
        navigationController.pushViewController(viewController, animated: true)
        self.navigationController.isNavigationBarHidden = true
    }
    
    func showPlayerView(musicItems: [MusicItems], musicId: Int16) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        let presenter = PlayerViewPresenter(view: viewController, idPlayTrack: musicId, musicItems: musicItems)
        
        viewController.presenter = presenter
        
        viewController.modalTransitionStyle = .coverVertical // Анимация снизу вверх
        
        
        presenter.closeView = {
            self.navigationController.dismiss(animated:true)
        }
        
        navigationController.present(viewController, animated: true)
    }
}
