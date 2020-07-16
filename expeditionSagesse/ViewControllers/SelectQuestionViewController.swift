//
//  SelectQuestionViewController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit


class SelectQuestionViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playersStackView: UIStackView!
    @IBOutlet weak var talkingPlayersView: UIView!
    @IBOutlet weak var talkingPlayersLabel: UILabel!
    @IBOutlet weak var talkingPlayersStackView: UIStackView!
    @IBOutlet weak var judgePlayersView: UIView!
    @IBOutlet weak var judgePlayersLabel: UILabel!
    @IBOutlet weak var judgePlayersStackView: UIStackView!
    @IBOutlet weak var questionSelectionView: UIView!
    @IBOutlet weak var questionSelectionLabel: UILabel!
    @IBOutlet weak var questionSelectionStackView: UIStackView!
    @IBOutlet weak var startQuestionButton: UIButton!
    
    private var party: Party?

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

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "\(party.totalQuestions)")

        talkingPlayersView.layer.borderWidth = 2
        talkingPlayersView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        talkingPlayersView.backgroundColor = .white

        talkingPlayersLabel.text = NSLocalizedString("selectQuestion.talkingPlayersLabel", comment: "Orators")

        for player in party.talkingPlayers[party.currentQuestion] {
            if let playerName = player.name, let playerAvatar = player.avatar, let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?[0] as? PlayerView {
                playerView.configure(playerName: playerName, playerAvatar: playerAvatar)
                talkingPlayersStackView.addArrangedSubview(playerView)
            }
        }

        judgePlayersView.layer.borderWidth = 2
        judgePlayersView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        judgePlayersView.backgroundColor = .white

        judgePlayersLabel.text = NSLocalizedString("selectQuestion.judgePlayersLabel", comment: "Auditors")

        for player in party.judgePlayers[party.currentQuestion] {
            if let playerName = player.name, let playerAvatar = player.avatar, let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?[0] as? PlayerView {
                playerView.configure(playerName: playerName, playerAvatar: playerAvatar)
                judgePlayersStackView.addArrangedSubview(playerView)
            }
        }

        questionSelectionView.layer.borderWidth = 2
        questionSelectionView.layer.borderColor = Helper.UIColorFromHex(0x02AAB0).cgColor
        questionSelectionView.backgroundColor = .white

        questionSelectionLabel.text = NSLocalizedString("selectQuestion.selectQuestionLabel", comment: "Orators")

        
        if let currentQuestions = party.questionsSets[party.currentQuestion].questions {
            if let question1View = Bundle.main.loadNibNamed("QuestionCardView", owner: self, options: nil)?[0] as? QuestionCardView {
                if currentQuestions.count > 0, let labels = currentQuestions[0].labels {
                    let localLanguage = Locale.current.languageCode?.uppercased() ?? "FR"
                    let question = labels[localLanguage] ?? labels["FR"] ?? ""

                    question1View.configure(identifier: 0, question: question, delegate: self)
                    questionSelectionStackView.addArrangedSubview(question1View)
                }
            }
            if let question2View = Bundle.main.loadNibNamed("QuestionCardView", owner: self, options: nil)?[0] as? QuestionCardView {
                if currentQuestions.count > 1, let labels = currentQuestions[1].labels{
                    let localLanguage = Locale.current.languageCode?.uppercased() ?? "FR"
                    let question = labels[localLanguage] ?? labels["FR"] ?? ""

                    question2View.configure(identifier: 1, question: question, delegate: self)
                    questionSelectionStackView.addArrangedSubview(question2View)
                }
            }
        }

        startQuestionButton.setTitle( NSLocalizedString("selectQuestion.startQuestionButton.label", comment: "Start question"), for: .normal)
        startQuestionButton.applyGradient(colors: [Helper.UIColorFromHex(0x4F4E4E).cgColor, Helper.UIColorFromHex(0xA9A6A6).cgColor])
        startQuestionButton.isEnabled = false
        startQuestionButton.setTitleColor(.white, for: .disabled)
       
    }

    @IBAction func startQuestion() {
        if self.party?.currentSelectedQuestion != nil {
            if let questionTurnViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.QuestionTurnVC.rawValue) as? QuestionTurnViewController {
                if let party = self.party {
                    questionTurnViewController.configure(party: party)
                    questionTurnViewController.modalPresentationStyle = .fullScreen
                    self.present(questionTurnViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension SelectQuestionViewController: QuestionCardViewDelegate {
    func questionCardDidTap(identifier: Int) {
        self.party?.currentSelectedQuestion = identifier
        startQuestionButton.isEnabled = true
        startQuestionButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        
        if let question1View = questionSelectionStackView.arrangedSubviews[0] as? QuestionCardView, let question2View = questionSelectionStackView.arrangedSubviews[1] as? QuestionCardView {
            if identifier == 0 {
                question1View.setBorderColor(color: UIColor.red.cgColor)
                question2View.setBorderColor(color: Helper.UIColorFromHex(0x02AAB0).cgColor)
            } else {
                question1View.setBorderColor(color: Helper.UIColorFromHex(0x02AAB0).cgColor)
                question2View.setBorderColor(color: UIColor.red.cgColor)
            }
        }
    }
}
