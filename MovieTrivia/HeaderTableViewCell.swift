//
//  HeaderTableViewCell.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/6/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerLabel.layer.cornerRadius = 10.0
        headerLabel.layer.masksToBounds = true
    }
}
