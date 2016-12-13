//
//  ColorPickerViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/12/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ColorPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "colorCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCell
        
        cell.colorView.layer.cornerRadius = cell.colorView.frame.width / 2
        cell.colorView.backgroundColor = UIColor.red
        
        return cell
    }
}
