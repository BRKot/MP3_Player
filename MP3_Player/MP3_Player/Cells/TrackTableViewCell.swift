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
                    authorName: String){
        self.trackNameLabel.text = trackName
        self.authorNameLabel.text = authorName
        self.coverImageView.image = coverImage
        self.idCell = idCell
    }
}
