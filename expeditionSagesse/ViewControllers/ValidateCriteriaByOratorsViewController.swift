//
//  ValidateCriteriaByOratorsViewController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 14/06/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


class ValidateCriteriaByOratorsViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var talkingPlayersView: UIView!
    @IBOutlet weak var talkingPlayersStackView: UIStackView!
    
    
    @IBOutlet weak var criteriasCollectionView: UICollectionView!
    
    private var party: Party?
    
    // MARK: Collection View properties
    let criteriaCollectionViewCellID = "criteriaCollectionViewCellID"
    private let sectionInsets = UIEdgeInsets(top: 5.0,
                                             left: 0.0,
                                             bottom: 5.0,
                                             right: 0.0)
    private let itemsPerRow: CGFloat = 3
    
    // MARK: - public
    public func configure(party: Party) {
        self.party = party
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let party = self.party else {
            return
        }

        if let wallpaperImage = UIImage(named: AppConfiguration.backgroundImageName) {
            backgroundView.backgroundColor = UIColor(patternImage: wallpaperImage)
        }
        
        questionView.layer.borderWidth = 2
        questionView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        questionView.backgroundColor = .white

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "\(party.totalQuestions)")
        questionLabel.text = NSLocalizedString("validate.criteria.question", comment: "Orateurs, vous avez bien répondu à la question,\n vous pouvez valider une carte critère de votre choix.")

        talkingPlayersView.layer.borderWidth = 2
        talkingPlayersView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        talkingPlayersView.backgroundColor = .white

        for player in party.talkingPlayers[party.currentQuestion] {
            if let playerName = player.name, let playerAvatar = player.avatar, let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?[0] as? PlayerView {
                playerView.configure(playerName: playerName, playerAvatar: playerAvatar)
                talkingPlayersStackView.addArrangedSubview(playerView)
            }
        }
    }
    
    func displayPartyFinished(){
       if let partyFinishedController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: ViewControllersID.PartyFinishedVC.rawValue) as? PartyFinishedViewController {
            partyFinishedController.modalPresentationStyle = .overFullScreen
            partyFinishedController.configure(party: self.party!)
            self.present(partyFinishedController, animated: true)
        }
    }
    
}


extension ValidateCriteriaByOratorsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        party?.displayedCriterias.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criteriaCollectionViewCellID, for: indexPath) as! CriteriaCollectionViewCell
        
        if let criteria =  party?.displayedCriterias[indexPath.row] {
            cell.configure(withCriteria: criteria, shouldDisplayAuditorsImages: false)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let party = self.party {
            let selectedCriteria = party.displayedCriterias[indexPath.row] 
            let criteria = party.validateCriteriaAndPullNewOne(criteriaToValidate: selectedCriteria)
            if criteria != nil && party.currentQuestion < party.totalQuestions - 1 {
                party.nextQuestion()
                if let selectQuestionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.SelectQuestionVC.rawValue) as? SelectQuestionViewController {
                    
                    selectQuestionController.configure(party: party)
                    selectQuestionController.modalPresentationStyle = .fullScreen
                    self.present(selectQuestionController, animated: true, completion: nil)
                }
            } else {
                displayPartyFinished()
            }
        }
        
    }
}


// MARK: - Collection View Flow Layout Delegate
extension ValidateCriteriaByOratorsViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 100, height: 97)
  }
    
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
