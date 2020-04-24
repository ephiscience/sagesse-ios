//
//  Party.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation

public class Party {
    var players: [Player]
    var currentQuestion: Int = 0
    var questionPlayers: [[Player]] = []
    var criteriaPlayers: [[Player]] = []

    public init(players: [Player]) {
        self.players = players
    }

    public func nextQuestion() {
        self.currentQuestion += 1
    }

    public func setTeams() {
        for question in 1...8 {
            setQuestionPlayers(question: question)
            self.criteriaPlayers.append(getUnpickedPlayers(question: question))
        }
    }

    private func setQuestionPlayers(question: Int) {
        if question == 0 {
            var questionPlayers: [Player] = []
            for _ in 1...getQuestionPlayersNumber() {
                questionPlayers.append(getUnpickedPlayers(question: 0)[Int.random(in: 0...getUnpickedPlayers(question: 0).count)])
            }
            self.questionPlayers.append(questionPlayers)
        } else {
            
        }
    }

    private func getQuestionPlayersQuestionCount(player: Player) -> Int {
        var result: Int = 0
        for questionPlayers in self.questionPlayers {
            if questionPlayers.contains(where: { $0.identifier == player.identifier }) {
                result += 1
            }
        }
        return result
    }

    private func getQuestionPlayersNumber() -> Int {
        switch self.players.count {
        case 3:
            return 2
        case 4:
            return 2
        case 5:
            return 3
        case 6:
            return 3
        default:
            return -1
        }
    }

    private func getUnpickedPlayers(question: Int) -> [Player] {
        var result: [Player] = []
        for player in self.players {
            if !self.questionPlayers[question].contains(where: { $0.identifier == player.identifier }) && !self.criteriaPlayers[question].contains(where: { $0.identifier == player.identifier }) {
                result.append(player)
            }
        }
        return result
    }
}
