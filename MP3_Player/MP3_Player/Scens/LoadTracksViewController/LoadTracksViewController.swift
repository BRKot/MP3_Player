//
//  LoadTracksViewController.swift
//  MP3_Player
//
//  Created by Databriz on 17/01/2025.
//

import Foundation
import UIKit


protocol LoadTracksView{
   
}

class LoadTracksViewController: UIViewController {
    
    var presenter: LoadTracksPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = LoadTracksPresenter(view: self)
    }
}

extension LoadTracksViewController: LoadTracksView{
    
}

