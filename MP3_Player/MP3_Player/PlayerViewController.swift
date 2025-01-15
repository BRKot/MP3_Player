//
//  ViewController.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit

protocol PlayerView{
    func configurCoverImageView(image: UIImage)
    
    func configurTrackNameLabel(name: String)
    func configurAuthorNameLabel(name: String)
    
    func configurTrackTimeSlider(image: UIImage)
    
    func configurTrackBackButton()
    func configurPlayTrackButton(image: UIImage)
    func configurTrackForwardButton()
}

class PlayerViewController: UIViewController {

    @IBOutlet var TrackCoverUIImageView: UIImageView!
    
    @IBOutlet var TrackNameLabel: UILabel!
    @IBOutlet var AuthorNameLabel: UILabel!
    
    @IBOutlet var TrackTimeSlider: UISlider!
    
    @IBOutlet var TrackBackButton: UIButton!
    @IBOutlet var PlayTrackButton: UIButton!
    @IBOutlet var TrackForwardButton: UIButton!
    
    var presenter: PlayerViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension PlayerViewController: PlayerView{
    func configurCoverImageView(image: UIImage) {
        
    }
    
    func configurTrackNameLabel(name: String) {
        
    }
    
    func configurAuthorNameLabel(name: String) {
        
    }
    
    func configurTrackTimeSlider(image: UIImage) {
        
    }
    
    func configurTrackBackButton() {
        
    }
    
    func configurPlayTrackButton(image: UIImage) {
        
    }
    
    func configurTrackForwardButton() {
        
    }
    

}

