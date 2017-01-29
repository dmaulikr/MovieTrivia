//
//  CustomButton.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/6/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.25
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.titleLabel!.font = UIFont(name: "Futura", size: 17)
        self.setBackgroundImage(backgroundHighlighted, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.black, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
               self.layer.borderColor = UIColor.white.cgColor
            } else {
                self.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    let backgroundHighlighted: UIImage = {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }()
}
