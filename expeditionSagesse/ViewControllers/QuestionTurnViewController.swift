//
//  QuestionTurnViewController.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 01/05/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


class QuestionTurnViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var talkingPlayersView: UIView!
    @IBOutlet weak var talkingPlayersStackView: UIStackView!
    @IBOutlet weak var questionStackView: UIStackView!
    
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

        if let wallpaperImage = UIImage(named: "wallpaper") {
            backgroundView.backgroundColor = UIColor(patternImage: wallpaperImage)
        }

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "\(party.totalQuestions)")

        talkingPlayersView.layer.borderWidth = 2
        talkingPlayersView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        talkingPlayersView.backgroundColor = .white

        for player in party.talkingPlayers[party.currentQuestion] {
            if let playerName = player.name, let playerAvatar = player.avatar, let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?[0] as? PlayerView {
                playerView.configure(playerName: playerName, playerAvatar: playerAvatar)
                talkingPlayersStackView.addArrangedSubview(playerView)
            }
        }

        if let currentQuestions = party.questionsSets[party.currentQuestion].questions {
            if let questionViewContent = Bundle.main.loadNibNamed("QuestionCardView", owner: self, options: nil)?[0] as? QuestionCardView {
                if let currentSelectedQuestion = party.currentSelectedQuestion, currentQuestions.count > currentSelectedQuestion, let labels = currentQuestions[currentSelectedQuestion].labels, let question = labels[Locale.current.languageCode?.uppercased() ?? "EN"] {
                    questionViewContent.configure(identifier: nil, question: question, delegate: nil)
                    questionStackView.addArrangedSubview(questionViewContent)
                }
            }
        }
    }
}

extension QuestionTurnViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criteriaCollectionViewCellID, for: indexPath) as! CriteriaCollectionViewCell
        
        cell.criteriaLabel.text = "Définir"
        return cell
    }
    
    
}

// MARK: - Collection View Flow Layout Delegate
extension QuestionTurnViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: 100, height: 97)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
