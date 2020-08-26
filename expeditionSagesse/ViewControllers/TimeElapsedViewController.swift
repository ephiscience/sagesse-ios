//
//  TimeElapsedViewController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 14/06/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


class TimeElapsedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    private var party: Party?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yesButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        self.noButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        
        titleLabel.text = NSLocalizedString("time.elapsed.alert.title", comment: "Temps écoulé")
        questionLabel.text = NSLocalizedString("time.elapsed.alert.question", comment: "Auditeurs, considérez vous que les orateurs ont bien répondu à la question?")
        yesButton.setTitle(NSLocalizedString("time.elapsed.alert.yes.button", comment: "Oui"), for: .normal)
        noButton.setTitle(NSLocalizedString("time.elapsed.alert.no.button", comment: "Non"), for: .normal)
        
    }
    
    // MARK: - public
    public func configure(party: Party) {
        self.party = party
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == SegueIdentifier.ValidateCriteriaByOratorsSegue.rawValue) {
            let validateController : ValidateCriteriaByOratorsViewController = segue.destination as! ValidateCriteriaByOratorsViewController
            validateController.configure(party: self.party!)
        }
    }
    
    
    @IBAction func didTapNo(){
        guard let party = self.party else {
            return
        }
        //if last question, display party finished
        if party.currentQuestion == party.totalQuestions - 1 {
            if let partyFinishedController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: ViewControllersID.PartyFinishedVC.rawValue) as? PartyFinishedViewController {
                partyFinishedController.modalPresentationStyle = .overFullScreen
                partyFinishedController.configure(party: self.party!)
                self.present(partyFinishedController, animated: true)
            }
        } else {
            party.nextQuestion()
            if let selectQuestionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.SelectQuestionVC.rawValue) as? SelectQuestionViewController {
                
                selectQuestionController.configure(party: party)
                selectQuestionController.modalPresentationStyle = .overFullScreen
                self.present(selectQuestionController, animated: true, completion: nil)
            }
        }
    }
}
