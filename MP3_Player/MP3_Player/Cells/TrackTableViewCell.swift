//
//  MusicTableViewCell.swift
//  MP3_Player
//
//  Created by Databriz on 17/01/2025.
//

import Foundation
import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    
    @IBOutlet var gifImageView: UIImageView!
    
    
    private var idCell: Int16?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var getIdCell: Int16?{
        return self.idCell
    }
    
    func configureCell(idCell: Int16,
                       coverImage: UIImage,
                       trackName: String,
                       authorName: String,
                       isPlaying: Bool){
        self.idCell = idCell
        
        self.trackNameLabel.text = trackName
        self.authorNameLabel.text = authorName
        
        self.coverImageView.image = coverImage
        self.coverImageView.layer.cornerRadius = self.coverImageView.bounds.width / 9 // Укажите нужное значение радиуса
        self.coverImageView.layer.masksToBounds = true
        
        self.gifImageView.image = nil
        if isPlaying{
            if let gifImage = UIImage.animatedImage(withGIFNamed: "dance_dog") {
                self.gifImageView.image = gifImage
                self.gifImageView.clipsToBounds = true
                self.gifImageView.layer.cornerRadius = self.gifImageView.bounds.width / 2 // Укажите нужное значение радиуса
                self.gifImageView.layer.masksToBounds = true
            }
        }
    }
    
    func startGif(){
        if let gifImage = UIImage.animatedImage(withGIFNamed: "dance_dog") {
            self.gifImageView.image = gifImage
            self.gifImageView.clipsToBounds = true
            self.gifImageView.layer.cornerRadius = self.gifImageView.bounds.width / 2 // Укажите нужное значение радиуса
            self.gifImageView.layer.masksToBounds = true
        }
    }
    
    func stopGif(){
        gifImageView.image = nil
    }
    
}
