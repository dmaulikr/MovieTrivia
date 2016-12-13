//
//  PlayerPickerViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/6/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class PlayerPickerViewController: UIViewController {
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial picker value.
        
        pickerView.selectRow(1, inComponent: 0, animated: false)
    }
}

extension PlayerPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //----------------------------------
    // MARK: Picker View Delegate
    //----------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var title = NSAttributedString()
        title = NSAttributedString(string: String(row + 1), attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 17.0)!, NSForegroundColorAttributeName: UIColor.white])
        pickerLabel.attributedText = title
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}


