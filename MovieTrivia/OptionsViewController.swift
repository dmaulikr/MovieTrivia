//
//  OptionsViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 1/2/17.
//  Copyright © 2017 Theodore Rothrock. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var strikeStepper: UIStepper!
    @IBOutlet weak var strikeCountLabel: UILabel!
    @IBOutlet weak var strikeCountContainer: UIView!
    @IBOutlet weak var quitButton: CustomButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyChanges))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        strikeCountContainer.layer.cornerRadius = strikeCountContainer.frame.width / 2
        strikeCountContainer.layer.masksToBounds = true
        
        strikeStepper.minimumValue = 1.0
        strikeStepper.maximumValue = 10.0
        strikeStepper.value = Double(UserDefaults.standard.integer(forKey: "strikeMax"))
        strikeCountLabel.text = String(Int(strikeStepper.value))
    }
    
    func applyChanges() {
        
        UserDefaults.standard.set(Int(strikeStepper.value), forKey: "strikeMax")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        
        strikeCountLabel.text = String(Int(strikeStepper.value))
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
