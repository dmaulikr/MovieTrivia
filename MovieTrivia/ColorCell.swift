//
//  ColorCell.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/13/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func styleCell(color: UIColor) {

        self.colorView.layer.cornerRadius = 10.0
        self.colorView.layer.borderWidth = 2.0
        self.colorView.layer.borderColor = UIColor.white.cgColor
        self.colorView.backgroundColor = color
        self.playerLabel.isHidden = true
    }
}
