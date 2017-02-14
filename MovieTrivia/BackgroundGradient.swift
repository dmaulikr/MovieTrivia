//
//  BackgroundGradient.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 2/8/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {
    
    var center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    var radius: CGFloat = 20
    var colors: [CGColor] = [UIColor.red.cgColor, UIColor.black.cgColor]
    
    override init(){
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    init(center: CGPoint, radius: CGFloat, colors: [CGColor]) {
        
        self.center = center
        self.radius = radius
        self.colors = colors
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: [])
    }
}
