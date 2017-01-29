//
//  LandingPageViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/28/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
