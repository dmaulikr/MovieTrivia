//
//  ScoreCell.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/31/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class ScoreCell: UICollectionViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func styleCell(color: UIColor) {
        
        self.colorView.layer.cornerRadius = 5.0
        self.colorView.layer.borderWidth = 1.25
        self.colorView.layer.borderColor = UIColor.white.cgColor
        self.colorView.backgroundColor = color
    }
}
