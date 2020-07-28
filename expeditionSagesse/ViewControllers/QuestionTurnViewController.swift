//
//  QuestionTurnViewController.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 01/05/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QuestionTurnViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var talkingPlayersView: UIView!
    @IBOutlet weak var talkingPlayersStackView: UIStackView!
    @IBOutlet weak var questionStackView: UIStackView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerTitleLabel: UILabel!
    @IBOutlet weak var remainingCriteriasLabel: UILabel!
    @IBOutlet weak var remainingCriteriasTitleLabel: UILabel!
    
    @IBOutlet weak var criteriasCollectionView: UICollectionView!
    @IBOutlet weak var pauseButton: UIButton!
    
    private var party: Party?
    
    private var timer: Timer?
    var totalTime = 15//60*3
    
    
    private var audioPlayer: AVAudioPlayer?
    
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
        
        
        self.remainingCriteriasLabel.text = "\(party.pendingCriterias.count+party.displayedCriterias.count)"

        if let wallpaperImage = UIImage(named: AppConfiguration.backgroundImageName) {
            view.backgroundColor = UIColor(patternImage: wallpaperImage)
        }

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "\(party.totalQuestions)")
        timerTitleLabel.text = NSLocalizedString("question.turn.timer.title", comment: "Temps restant")
        remainingCriteriasTitleLabel.text = NSLocalizedString("question.turn.remaining.criterias.title", comment: "Critères à valider")
        pauseButton.setTitle(NSLocalizedString("question.turn.pause.button", comment: "Pause"), for: .normal)

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
                if let currentSelectedQuestion = party.currentSelectedQuestion, currentQuestions.count > currentSelectedQuestion, let labels = currentQuestions[currentSelectedQuestion].labels {
                    let localLanguage = Locale.current.languageCode?.uppercased() ?? "FR"
                    let question = labels[localLanguage] ?? labels["FR"] ?? ""

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
        if let pauseController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: ViewControllersID.PauseAlertVC.rawValue) as? PauseAlertViewController {
            pauseController.modalPresentationStyle = .overFullScreen
            pauseController.delegate = self
            self.present(pauseController, animated: true)
        }
    }
    
    @objc private func questionTimeout(){
        guard let party = self.party else {
            return
        }
        if let timeElapsedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.TimeElapsedVC.rawValue) as? TimeElapsedViewController {
            timeElapsedController.configure(party: party)
            timeElapsedController.modalPresentationStyle = .overFullScreen
            self.present(timeElapsedController, animated: true)
        }
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
            questionTimeout()
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func displayPartyFinished() {
        
        if let partyFinishedController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: ViewControllersID.PartyFinishedVC.rawValue) as? PartyFinishedViewController {
            partyFinishedController.modalPresentationStyle = .overFullScreen
            partyFinishedController.configure(party: self.party!)
            self.present(partyFinishedController, animated: true)
        }
    }
    
    func playCriteriaOneSound() {
        guard let url = Bundle.main.url(forResource: "ARCADE_Slide_Up", withExtension: "mp3") else { return }
        playSound(fromUrl: url)
    }
    
    func playCriteriaTwoSound() {
        guard let url = Bundle.main.url(forResource: "ARCADE_Slide_Down", withExtension: "mp3") else { return }
        playSound(fromUrl: url)
    }
    
    func playSound(fromUrl url: URL) {

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let audioPlayer = audioPlayer else { return }

            audioPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension QuestionTurnViewController: PauseAlertViewControllerDelegate{
    func resumeGame() {
         self.dismiss(animated: true)
        startTimer()
    }
    func exitGame() {
        self.dismiss(animated: true)
        if let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.HomeVC.rawValue) as? HomeViewController {
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
}

extension QuestionTurnViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        party?.displayedCriterias.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criteriaCollectionViewCellID, for: indexPath) as! CriteriaCollectionViewCell
        
        if let criteria =  party?.displayedCriterias[indexPath.row] {
            cell.configure(withCriteria: criteria, shouldDisplayAuditorsImages: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CriteriaCollectionViewCell {
            guard let party = self.party else {
                return
            }
            
//            print("*** displayed criterias ----->")
//            for item in party.displayedCriterias {
//                print("\n***                         \(item.title)/ validated :\(item.validatedAuditors) ")
//            }
            var criteria = party.displayedCriterias[indexPath.row]
            criteria.validatedAuditors = criteria.validatedAuditors + 1
            party.displayedCriterias[indexPath.row] = criteria
           
//            print("$$$ displayed criterias ----->")
//                       for item in party.displayedCriterias {
//                           print("\n***                         \(item.title)/ validated :\(item.validatedAuditors) ")
//                       }
            
            cell.didAuditorValidated(withCriteria: criteria)
            if criteria.validatedAuditors >= 2 {
                playCriteriaTwoSound()
                let _ = self.party?.validateCriteriaAndPullNewOne(criteriaToValidate: cell.criteria!)
//                print("€€€ displayed criterias ----->")
//                           for item in party.displayedCriterias {
//                               print("\n***                         \(item.title)/ validated :\(item.validatedAuditors) ")
//                           }
                collectionView.reloadData()
                self.remainingCriteriasLabel.text = "\(self.party!.pendingCriterias.count + party.displayedCriterias.count)"
                if party.pendingCriterias.isEmpty && party.displayedCriterias.isEmpty {
                    displayPartyFinished()
                }
            } else {
                playCriteriaOneSound()
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
