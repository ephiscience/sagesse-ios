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
    
    private var party: Party?

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
