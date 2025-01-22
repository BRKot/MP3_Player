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
    
    func configureSwaps()
}

class PlayerViewController: UIViewController {
    @IBOutlet var trackCoverUIImageView: UIImageView!
    
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    
    @IBOutlet var trackTimeSlider: UISlider!
    
    @IBOutlet var trackBackButton: UIButton!
    @IBOutlet var playTrackButton: UIButton!
    @IBOutlet var trackForwardButton: UIButton!
    
    var presenter: PlayerViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupUI()
    }

    @IBAction func onPlayButtonTuch(_ sender: Any) {
        presenter?.tupOnPlayOrStopButton()
    }
    
    @IBAction func changeValueSlider(_ sender: Any) {
        presenter?.changeTrackTime(partFullTime: Double(self.trackTimeSlider.value))
    }
    
    @IBAction func onTupNextTrack(_ sender: Any) {
        presenter?.playNextTrack()
    }
    
    @IBAction func onTupBackTrack(_ sender: Any) {
        presenter?.playBackTrack()
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
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
           switch gesture.direction {
           case .left:
               print("Свайп влево")
               presenter?.playNextTrack()
           case .right:
               print("Свайп вправо")
               presenter?.playBackTrack()
           default:
               break
           }
       }
    
}

extension PlayerViewController: PlayerView{
    
    func configurCoverImageView(image: UIImage) {
        self.trackCoverUIImageView.layer.cornerRadius = trackTimeSlider.frame.width / 15
        self.trackCoverUIImageView.image = image
    }
    
    func configurTrackNameLabel(atributs: NSAttributedString) {
        self.trackNameLabel.attributedText = atributs
    }
    
    func configurAuthorNameLabel(atributs: NSAttributedString) {
        self.authorNameLabel.attributedText = atributs
    }
    
    func configurTrackTimeSlider(value: Float) {
        self.trackTimeSlider.value = value
    }
    
    func addTrackTimeSliderTargets() {
        trackTimeSlider.addTarget(self, action: #selector(sliderBeganSliding), for: .touchDown)
        trackTimeSlider.addTarget(self, action: #selector(sliderEndedSliding), for: [.touchUpInside, .touchUpOutside])
    }
    
    func configurTrackBackButton(image: UIImage) {
        self.trackBackButton.setImage(image, for: .normal)
        self.trackBackButton.tintColor = UIColor.white
    }
    
    func configurPlayTrackButton(image: UIImage) {
        self.playTrackButton.setImage(image, for: .normal)
        self.playTrackButton.tintColor = UIColor.white
    }
    
    func configurTrackForwardButton(image: UIImage) {
        self.trackForwardButton.setImage(image, for: .normal)
        self.trackForwardButton.tintColor = UIColor.white
    }
    
    func configureSwaps(){
        trackCoverUIImageView.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        trackCoverUIImageView.addGestureRecognizer(swipeRight)
        
        // Свайп влево
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        trackCoverUIImageView.addGestureRecognizer(swipeLeft)
    }
}
