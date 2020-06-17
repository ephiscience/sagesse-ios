//
//  PauseAlertViewController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 07/06/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


protocol PauseAlertViewControllerDelegate {
    func resumeGame()
    func exitGame()
}

class PauseAlertViewController: UIViewController {
    
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    var delegate: PauseAlertViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resumeButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        self.exitButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
    }
    
    @IBAction func didTapResume(){
        self.delegate?.resumeGame()
    }
    
    @IBAction func didTapExit(){
         self.delegate?.exitGame()
    }
}
