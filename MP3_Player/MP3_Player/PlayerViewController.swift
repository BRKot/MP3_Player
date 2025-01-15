//
//  ViewController.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit
import AVFoundation

protocol PlayerView{
    func configurCoverImageView(image: UIImage)
    
    func configurTrackNameLabel(name: String)
    func configurAuthorNameLabel(name: String)
    
    func configurTrackTimeSlider(value: Float)
    
    func configurTrackBackButton()
    func configurPlayTrackButton(image: UIImage)
    func configurTrackForwardButton()
}

class PlayerViewController: UIViewController {
    @IBOutlet var trackCoverUIImageView: UIImageView!
    
    @IBOutlet var TrackNameLabel: UILabel!
    @IBOutlet var AuthorNameLabel: UILabel!
    
    @IBOutlet var trackTimeSlider: UISlider!
    
    @IBOutlet var TrackBackButton: UIButton!
    @IBOutlet var playTrackButton: UIButton!
    @IBOutlet var TrackForwardButton: UIButton!
    
    var presenter: PlayerViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PlayerViewPresenter(view: self)
        presenter?.setupUI()
    }
    
    @IBAction func onPlayButtonTuch(_ sender: Any) {
        presenter?.isPlaing = !presenter!.isPlaing
    }
    
    @IBAction func changeValueSlider(_ sender: Any) {
        presenter?.changeTrackTime(partFullTime: Double(self.trackTimeSlider.value))
    }
}

extension PlayerViewController: PlayerView{
    func configurCoverImageView(image: UIImage) {
        self.trackCoverUIImageView.layer.cornerRadius = trackTimeSlider.frame.width / 15
        self.trackCoverUIImageView.image = image
    }
    
    func configurTrackNameLabel(name: String) {
        
    }
    
    func configurAuthorNameLabel(name: String) {
        
    }
    
    func configurTrackTimeSlider(value: Float) {
        self.trackTimeSlider.value = value
    }
    
    func configurTrackBackButton() {
        
    }
    
    func configurPlayTrackButton(image: UIImage) {
          self.playTrackButton.setImage(image, for: .normal)
          self.playTrackButton.tintColor = UIColor.white
      }
    
    func configurTrackForwardButton() {
        
    }
}
