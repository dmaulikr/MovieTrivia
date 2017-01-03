//
//  ColorPickerViewController.swift
//  MovieTrivia
//
//  Created by Theodore Rothrock on 12/12/16.
//  Copyright © 2016 Theodore Rothrock. All rights reserved.
//

import UIKit
import CoreData

class ColorPickerViewController: UIViewController {
    
    //----------------------------------
    // MARK: Properties
    //----------------------------------
    
    var game: Game? = nil
    var currentPlayerIndex = 0
    var managedObjectContext: NSManagedObjectContext {return CoreDataStackManager.sharedInstance.managedObjectContext}
    
    // Colors
    
    var red = UIColor(red:0.85, green:0.12, blue:0.09, alpha:1.0)
    var pink = UIColor(red:0.86, green:0.04, blue:0.36, alpha:1.0)
    var blue = UIColor(red:0.27, green:0.42, blue:0.70, alpha:1.0)
    var green = UIColor(red:0.15, green:0.65, blue:0.36, alpha:1.0)
    var orange = UIColor(red:0.98, green:0.41, blue:0.1, alpha:1.0)
    var purple = UIColor(red:0.60, green:0.07, blue:0.70, alpha:1.0)
    var grey = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
    var turquoise = UIColor(red:0.01, green:0.79, blue:0.66, alpha:1.0)
    
    var colorArray: [UIColor] {return [red, pink, blue, green, orange, purple, grey, turquoise]}
    
    //----------------------------------
    // MARK: Outlets
    //----------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var continueButton: CustomButton!
    
    //----------------------------------
    // MARK: Lifecycle
    //----------------------------------

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        continueButton.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.reset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            CoreDataStackManager.sharedInstance.deleteGame() { error in
                // TODO: Handle error.
            }
        }
    }
    
    //----------------------------------
    // MARK: Page Methods
    //----------------------------------
    
    func reset() {
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        currentPlayerIndex = 0
        picker.selectRow(0, inComponent: 0, animated: true)
        continueButton.isEnabled = false
        
        for cell in collectionView.visibleCells as! [ColorCell] {
            cell.playerLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let gameplayViewController = segue.destination as! GameplayViewController
        gameplayViewController.game = self.game
    }
}

extension ColorPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return game!.players!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var title = NSAttributedString()
        title = NSAttributedString(string: String(game!.players![row].name), attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 17.0)!, NSForegroundColorAttributeName: UIColor.white])
        pickerLabel.attributedText = title
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}

extension ColorPickerViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        cell.styleCell(color: colorArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        
        guard cell.playerLabel.isHidden && currentPlayerIndex <= game!.players!.count - 1 else {return}
        
        if currentPlayerIndex == 0 {navigationItem.rightBarButtonItem?.isEnabled = true}
        cell.playerLabel.text = "P" + "\(game!.players![currentPlayerIndex].name.components(separatedBy: " ")[1])"
        cell.playerLabel.isHidden = false
        game!.players![currentPlayerIndex].color = colorArray[indexPath.row]
        currentPlayerIndex += 1
        picker.selectRow(currentPlayerIndex, inComponent: 0, animated: true)
        
        if currentPlayerIndex == game!.players!.count {
            continueButton.isEnabled = true
        }
    }
}
