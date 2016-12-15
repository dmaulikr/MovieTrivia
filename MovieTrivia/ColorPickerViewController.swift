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
    // MARK: Properties
    //----------------------------------
    
    var game: Game? = nil
    var currentPlayer: Player? = nil
    
    // Colors
    
    var red = UIColor(red:0.85, green:0.12, blue:0.09, alpha:1.0)
    var pink = UIColor(red:0.86, green:0.04, blue:0.36, alpha:1.0)
    var blue = UIColor(red:0.27, green:0.42, blue:0.70, alpha:1.0)
    var green = UIColor(red:0.15, green:0.65, blue:0.36, alpha:1.0)
    var orange = UIColor(red:0.98, green:0.41, blue:0.1, alpha:1.0)
    var purple = UIColor(red:0.60, green:0.07, blue:0.70, alpha:1.0)
    var grey = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
    var turquoise = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var picker: UIPickerView!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Colors"
    }
}

extension ColorPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return game!.players.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var title = NSAttributedString()
        title = NSAttributedString(string: String(game!.players[row].name), attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 17.0)!, NSForegroundColorAttributeName: UIColor.white])
        pickerLabel.attributedText = title
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension ColorPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        
        let colors = [red, pink, blue, green, orange, purple, grey, turquoise]
        cell.styleCell(color: colors[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        
        cell.playerLabel.isHidden = !cell.playerLabel.isHidden
    }
}
