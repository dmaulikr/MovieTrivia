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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
