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
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var remainingCriteriasLabel: UILabel!
    
    @IBOutlet weak var criteriasCollectionView: UICollectionView!
    @IBOutlet weak var pauseButton: UIButton!
    
    private var party: Party?
    private var displayedCriterias: [PartyCriteria] = []
    
    private var timer: Timer?
    var totalTime = 60*3
    
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
        
        self.pauseButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        
        self.displayedCriterias = party.getInitialCriterias()
        self.remainingCriteriasLabel.text = "\(party.criterias.count+self.displayedCriterias.count)"

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
        
        self.timerLabel.text = self.timeFormatted(self.totalTime)
        startTimer()
    }
    
    @IBAction func pauseGameTapped(){
        pauseTimer()
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PauseAlertViewControllerID") as! PauseAlertViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc private func questionTimeout(){
        
    }
    
    private func pauseTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        self.timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension QuestionTurnViewController: PauseAlertViewControllerDelegate{
    func resumeGame(){
         self.dismiss(animated: true)
        startTimer()
    }
    func exitGame(){
         self.dismiss(animated: true)
    
    }
}

extension QuestionTurnViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.displayedCriterias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criteriaCollectionViewCellID, for: indexPath) as! CriteriaCollectionViewCell
        
        let criteria =  self.displayedCriterias[indexPath.row]
        
        cell.configure(withCriteria: criteria)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CriteriaCollectionViewCell {
            
            var criteria = self.displayedCriterias[indexPath.row]
            criteria.validatedAuditors = criteria.validatedAuditors + 1
            self.displayedCriterias[indexPath.row] = criteria
            
            cell.didAuditorValidated(withCriteria: criteria)
            if criteria.validatedAuditors >= 2 {
                if let newCriteria = self.party?.pullANewCriteria(criteria: cell.criteria!){
                    self.displayedCriterias[indexPath.row] = newCriteria
                    
                } else {
                    self.displayedCriterias.remove(at: indexPath.row)
                    
                }
                 collectionView.reloadData()
                self.remainingCriteriasLabel.text = "\(self.party!.criterias.count+self.displayedCriterias.count)"
                
                if totalTime > 0 && self.party!.criterias.isEmpty &&  self.displayedCriterias.isEmpty  {
                    //TODO SUCCESS
                    pauseTimer()
                    print("🎉🎉🎉 Success 🎉🎉🎉")
                } else if totalTime == 0 && (!self.party!.criterias.isEmpty || !self.displayedCriterias.isEmpty) {
                    //PROBLEM
                    print("💔💔💔 Echec et mat 💔💔💔")
                }
            }
        }
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
