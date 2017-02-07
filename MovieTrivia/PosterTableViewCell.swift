//
//  PosterTableViewCell.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/6/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage.layer.borderWidth = 2
        posterImage.layer.borderColor = UIColor.white.cgColor
        posterImage.layer.cornerRadius = 10.0
        posterImage.layer.masksToBounds = true
    }
}
