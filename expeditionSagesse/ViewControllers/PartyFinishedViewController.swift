//
//  PartyFinishedViewController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 18/06/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


class PartyFinishedViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var validateButton: UIButton!
    
    private var party: Party?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.validateButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        self.validateButton.setTitle(NSLocalizedString("game.finisehd.replay.button", comment: "Rejouer une partie"), for: .normal)
        if let party = self.party, party.isPartySucceeded {
                  imageView.image = UIImage(named: "medal-100")
                  titleLabel.text = NSLocalizedString("game.finished.congrats.title", comment: "Bravo!")
                  messageLabel.text = NSLocalizedString("game.finished.congrats.message", comment: "Vous avez gagné grâce à votre collaboration.")
              } else {
                  imageView.image = UIImage(named: "sad-sun-100")
                             titleLabel.text = NSLocalizedString("game.finished.failure.title", comment: "Zut!")
                             messageLabel.text = NSLocalizedString("game.finished.failure.message", comment: "Vous avez perdu cette fois-ci, la prochaine sera la bonne.")
              }
        
        
    }
    
    // MARK: - public
    public func configure(party: Party) {
        self.party = party
        self.party?.updateIsPartySucceeded()
    }
    
    @IBAction func replayAParty(_ sender: Any) {
        if let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.HomeVC.rawValue) as? HomeViewController {
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
}
