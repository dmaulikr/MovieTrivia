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
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        styleCell()
    }
    
    func styleCell() {

        self.colorView.layer.borderWidth = 2.0
        self.colorView.layer.borderColor = UIColor.white.cgColor
        self.colorView.layer.masksToBounds = true
        self.colorView.layer.cornerRadius  = self.colorView.frame.width / 2
    }
}
