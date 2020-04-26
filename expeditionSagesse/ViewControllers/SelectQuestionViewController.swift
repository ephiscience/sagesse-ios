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
    
    public var party: Party?

    public func configure(party: Party) {
        self.party = party
    }

    override func viewDidLoad() {

        guard let party = self.party else {
            return
        }

        if let wallpaperImage = UIImage(named: "wallpaper") {
            backgroundView.backgroundColor = UIColor(patternImage: wallpaperImage)
        }

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "8")

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
    }
}
