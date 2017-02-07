//
//  ActorTableViewCell.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/5/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        actorImage.layer.borderColor = UIColor.white.cgColor
        actorImage.layer.borderWidth = 2.0
        actorImage.layer.cornerRadius = 3.0
        actorImage.layer.masksToBounds = true
        
        activityIndicator.hidesWhenStopped = true
    }
}
