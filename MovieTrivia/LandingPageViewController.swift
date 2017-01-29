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
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var topCellView: UIView!
    @IBOutlet weak var middleCellView: UIView!
    @IBOutlet weak var bottomCellView: UIView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views: [UIView] = [topCellView, middleCellView, bottomCellView]
        
        for view in views {
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 4.0
            view.layer.cornerRadius = 10.0
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
