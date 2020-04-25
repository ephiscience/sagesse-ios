//
//  ViewController.swift
//  expeditionSagesseStoryboard
//
//  Created by Omar Mahboubi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import UIKit


class GameSettingsProvider  {
    
    static func getDifficultyLevels() -> [DifficultyLevel] {
        
        let easy  = DifficultyLevel(name: NSLocalizedString("difficulty.level.easy", comment: "easy"), numberOfCards: 12)
        let middle  = DifficultyLevel(name: NSLocalizedString("difficulty.level.middle", comment: "middle"), numberOfCards: 24)
        let hard  = DifficultyLevel(name: NSLocalizedString("difficulty.level.hard", comment: "hard"), numberOfCards: 36)
        return [easy, middle, hard]
    }
}


struct DifficultyLevel {
    var name: String
    var numberOfCards: Int
}


class HomeViewController: UIViewController {
   

    var possiblePlayersNumber : [Int] = [3, 4, 5, 6]
    
    @IBOutlet weak var playersNumberTitle: UILabel!
    @IBOutlet weak var playersNumberPicker: UIPickerView!
    
    @IBOutlet weak var gameDifficultyLabel: UILabel!
    @IBOutlet weak var gameDifficultyPicker: UIPickerView!
    
    @IBOutlet weak var nextStepButton: UIButton!
    
    let difficultyLevels = GameSettingsProvider.getDifficultyLevels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersNumberPicker.dataSource = self
        playersNumberPicker.delegate = self
        
        gameDifficultyPicker.delegate = self
        gameDifficultyPicker.dataSource = self
        
        self.nextStepButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == SegueIdentifier.ChoosePlayersNamesSegue.rawValue) {
            
            let playersController : PlayersViewController = segue.destination as! PlayersViewController
                
            playersController.playersNumber = possiblePlayersNumber[playersNumberPicker.selectedRow(inComponent: 0)]
            
        }
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK:-  Picker Data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return possiblePlayersNumber.count
        } else {
            return difficultyLevels.count
        }
    }
    
    // MARK:-  Picker Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(possiblePlayersNumber[row])
        } else {
            return difficultyLevels[row].name
        }
 
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{

        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }

        label.font = UIFont(name: "Avenir-Bold", size: 13.0)
        
        if pickerView.tag == 1 {
            label.text = String(possiblePlayersNumber[row])
        } else {
           label.text = difficultyLevels[row].name
        }

        label.textAlignment = .center
        return label

    }
    
    
}
