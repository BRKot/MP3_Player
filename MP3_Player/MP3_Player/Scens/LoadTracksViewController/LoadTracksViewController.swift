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
    
    weak var presenter: LoadTracksPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoadTracksViewController: LoadTracksView{
}

