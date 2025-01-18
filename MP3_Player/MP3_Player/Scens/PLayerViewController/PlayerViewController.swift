//
//  ViewController.swift
//  MP3_Player
//
//  Created by Databriz on 15/01/2025.
//

import UIKit
import AVFoundation

protocol PlayerView: AnyObject{
    func configurCoverImageView(image: UIImage)
    
    func configurTrackNameLabel(atributs: NSAttributedString)
    func configurAuthorNameLabel(atributs: NSAttributedString)
    
    func configurTrackTimeSlider(value: Float)
    func addTrackTimeSliderTargets()
     
    func configurTrackBackButton(image: UIImage)
    func configurPlayTrackButton(image: UIImage)
    func configurTrackForwardButton(image: UIImage)
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
        presenter?.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.playTrack()
    }
    
    @IBAction func onPlayButtonTuch(_ sender: Any) {
        presenter?.isPLaying = !(presenter?.isPLaying ?? false)
    }
    
    @IBAction func changeValueSlider(_ sender: Any) {
        presenter?.changeTrackTime(partFullTime: Double(self.trackTimeSlider.value))
    }
    
    @IBAction func onTupNextTrack(_ sender: Any) {
        presenter?.idPLayTrack += 1
    }
    
    @IBAction func onTupBackTrack(_ sender: Any) {
        presenter?.idPLayTrack += -1
    }
    
    @IBAction func closeButtonYup(_ sender: Any) {
        presenter?.onCloseView()
    }
    
    @objc func sliderBeganSliding() {
        presenter?.isSliding = true
    }

    @objc func sliderEndedSliding() {
        presenter?.isSliding = false
    }
    
}
    


extension PlayerViewController: PlayerView{
    
    func configurCoverImageView(image: UIImage) {
        self.trackCoverUIImageView.layer.cornerRadius = trackTimeSlider.frame.width / 15
        self.trackCoverUIImageView.image = image
    }
    
    func configurTrackNameLabel(atributs: NSAttributedString) {
        self.TrackNameLabel.attributedText = atributs
    }
    
    func configurAuthorNameLabel(atributs: NSAttributedString) {
        self.AuthorNameLabel.attributedText = atributs
    }
    
    func configurTrackTimeSlider(value: Float) {
        self.trackTimeSlider.value = value
    }
    
    func addTrackTimeSliderTargets() {
        trackTimeSlider.addTarget(self, action: #selector(sliderBeganSliding), for: .touchDown)
        trackTimeSlider.addTarget(self, action: #selector(sliderEndedSliding), for: [.touchUpInside, .touchUpOutside])
    }
    
    func configurTrackBackButton(image: UIImage) {
        self.TrackBackButton.setImage(image, for: .normal)
        self.TrackBackButton.tintColor = UIColor.white
    }
    
    func configurPlayTrackButton(image: UIImage) {
          self.playTrackButton.setImage(image, for: .normal)
          self.playTrackButton.tintColor = UIColor.white
      }
    
    func configurTrackForwardButton(image: UIImage) {
        self.TrackForwardButton.setImage(image, for: .normal)
        self.TrackForwardButton.tintColor = UIColor.white
    }
}
