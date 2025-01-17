//
//  ViewController.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit
import AVFoundation

protocol MusicLIstView{
   
}

class MusicLIstViewController: UIViewController {
    
    var presenter: PlayerViewPresenter?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension MusicLIstViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            cell.backgroundColor =  (indexPath.row % 2 == 0) ? UIColor.red : UIColor.white
        return cell
    }
    
    
}

extension MusicLIstViewController: MusicLIstView{
    
}
