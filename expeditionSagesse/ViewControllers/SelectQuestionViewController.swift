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
        // TO BE REMOVED
//        let player1 = Player(identifier: 0, name: "Omar")
//        player1.avatar = UIImage(named: "avatarLion")
//        let player2 = Player(identifier: 1, name: "Karim")
//        player2.avatar = UIImage(named: "avatarTiger")
//        let player3 = Player(identifier: 2, name: "Pleen")
//        player3.avatar = UIImage(named: "avatarSheep")
//        let player4 = Player(identifier: 3, name: "Lili")
//        player4.avatar = UIImage(named: "avatarTurtle")
//        let player5 = Player(identifier: 4, name: "Julien")
//        player5.avatar = UIImage(named: "avatarEagle")
//        let player6 = Player(identifier: 5, name: "Matthieu")
//        player6.avatar = UIImage(named: "avatarElephant")
//        let players: [Player] = [player1, player2, player3, player4, player5, player6]
//        let currentParty: Party = Party(players: players)
//        currentParty.setTeams()
//        self.party = currentParty

        guard let party = self.party else {
            return
        }

        if let wallpaperImage = UIImage(named: "wallpaper") {
            backgroundView.backgroundColor = UIColor(patternImage: wallpaperImage)
        }

        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("selectQuestion.title", comment: "Question a/n"), "\(party.currentQuestion + 1)", "8")

        talkingPlayersView.layer.borderWidth = 2
        talkingPlayersView.layer.borderColor = UIColor.gray.cgColor
        talkingPlayersView.backgroundColor = .white

        talkingPlayersLabel.text = NSLocalizedString("selectQuestion.talkingPlayersLabel", comment: "Orators")

        for player in party.talkingPlayers[party.currentQuestion] {
            if let playerName = player.name, let playerAvatar = player.avatar, let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?[0] as? PlayerView {
                playerView.configure(playerName: playerName, playerAvatar: playerAvatar)
                talkingPlayersStackView.addArrangedSubview(playerView)
            }
        }

        judgePlayersView.layer.borderWidth = 2
        judgePlayersView.layer.borderColor = UIColor.gray.cgColor
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
