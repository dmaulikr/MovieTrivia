//
//  LandingPageViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/28/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties & Outlets
    //----------------------------------
    
    @IBOutlet weak var titleImageView: UIImageView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        titleImageView.layer.cornerRadius = 10.0
        titleImageView.layer.borderColor = UIColor.white.cgColor
        titleImageView.layer.borderWidth = 2.0
        titleImageView.layer.masksToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        let radialGradient = RadialGradientLayer(center: self.view.center, radius: self.view.frame.height / 2, colors: [UIColor.red.cgColor, UIColor.black.cgColor])
        radialGradient.frame = self.view.bounds
        self.view.layer.insertSublayer(radialGradient, at: 0)
        radialGradient.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
