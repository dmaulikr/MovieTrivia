//
//  RadioButton.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 11/16/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.setBackgroundImage(#imageLiteral(resourceName: "checkmark"), for: UIControlState.selected)
    }
}
