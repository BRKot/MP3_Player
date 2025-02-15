//
//  ViewController.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit
import AVFoundation

protocol MusicLIstView: AnyObject{
    func reloadTableViewData()
    func setupTableView(reusIdentifier: String)
    func configureCellWithCurrentTrack(idCell: Int16)
}

class MusicLIstViewController: UIViewController {
    
    var presenter: MusicLIstPresenter?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupUI()
    }
    
    @IBAction func button(_ sender: Any) {
        self.reloadTableViewData()
    }
}

extension MusicLIstViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: presenter.reuseIdentifier, for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        
        guard let item = presenter.getEqualMusicItem(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configureCell(idCell: item.id,
                           coverImage: UIImage(data: item.coverImage ?? Data()) ?? UIImage(),
                           trackName: item.musicName ?? "",
                           authorName: item.author ?? "",
                           isPlaying: presenter.getPlayingId(index: item.id))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell, let idCell = cell.getIdCell else {
            return
        }
        presenter?.selectMusic(id: idCell)
    }
}

extension MusicLIstViewController: MusicLIstView{
    func configureCellWithCurrentTrack(idCell: Int16) {
        for cell in (self.tableView.visibleCells as? [TrackTableViewCell]) ?? []{
            cell.stopGif()
            if cell.getIdCell == idCell { cell.startGif()}
        }
    }
    
    
    func setupTableView(reusIdentifier: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: reusIdentifier, bundle: nil), forCellReuseIdentifier: reusIdentifier)
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
}
