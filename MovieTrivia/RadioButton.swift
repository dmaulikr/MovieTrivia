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
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .selected)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.clear
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
