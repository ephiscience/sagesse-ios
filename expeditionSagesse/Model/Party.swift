//
//  Party.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation

public struct PartyCriteria {
    var title: String
    var validatedAuditors: Int
}

public class Party {
    
    var players: [Player]
    var totalQuestions: Int = 8
    var currentQuestion: Int = 0
    public var talkingPlayers: [[Player]] = []
    public var judgePlayers: [[Player]] = []
    public var questionsSets: [QuestionsSet] = []
    public var currentSelectedQuestion: Int?
    public var criterias: [PartyCriteria] = []

    public init(players: [Player], criterias: [PartyCriteria]) {
        self.players = players
        self.criterias = criterias
    }

    public func nextQuestion() {
        self.currentQuestion += 1
    }

    public func setTeams() {
        for question in 0...(totalQuestions - 1) {
            self.talkingPlayers.append([])
            setTalkingPlayers(question: question)
            self.judgePlayers.append(getUnpickedPlayers(question: question))
        }
    }

    private func setTalkingPlayers(question: Int) {
        for _ in 1...getTalkingPlayersNumber() {
            self.talkingPlayers[question].append(getTalkingPlayersWithLessQuestionsCount(question: question)[Int.random(in: 0...(getTalkingPlayersWithLessQuestionsCount(question: question).count - 1))])
        }
    }

    private func getTalkingPlayersWithLessQuestionsCount(question: Int) -> [Player] {
        var talkingPlayersQuestionsCount: [Int:Int] = [:]
        for player in self.players {
            talkingPlayersQuestionsCount[player.identifier] = getTalkingPlayersQuestionsCount(player: player, question: question)
        }

        var maxQuestionsCount: Int = 0
        talkingPlayersQuestionsCount.forEach { (identifier: Int, count: Int) in
            if count > maxQuestionsCount {
                maxQuestionsCount = count
            }
        }

        let talkingPlayersWithLessQuestionsCount = talkingPlayersQuestionsCount.filter { (questionsCountPerPlayer) -> Bool in
            return questionsCountPerPlayer.value < maxQuestionsCount
        }

        if talkingPlayersWithLessQuestionsCount.isEmpty {
            return getUnpickedPlayers(question: question)
        } else {
            let result = getUnpickedPlayers(question: question).filter { (player) -> Bool in
                return talkingPlayersWithLessQuestionsCount.contains { (identifier: Int, count: Int) -> Bool in
                    return identifier == player.identifier
                }
            }

            return result
        }
    }

    private func getTalkingPlayersQuestionsCount(player: Player, question: Int) -> Int {
        var result: Int = 0
        for currentQuestion in 0...question {
            if self.talkingPlayers[currentQuestion].contains(where: { $0.identifier == player.identifier }) {
                result += 1
            }
        }

        return result
    }

    private func getTalkingPlayersNumber() -> Int {
        switch self.players.count {
        case 3:
            return 2
        case 4:
            return 2
        case 5:
            return 2
        case 6:
            return 2
        default:
            return -1
        }
    }

    private func getUnpickedPlayers(question: Int) -> [Player] {
        var result: [Player] = []
        for player in self.players {
            if question + 1 > self.talkingPlayers.count {
                if question + 1 > self.judgePlayers.count {
                    result.append(player)
                } else if !self.judgePlayers[question].contains(where: { $0.identifier == player.identifier }) {
                    result.append(player)
                }
            } else if !self.talkingPlayers[question].contains(where: { $0.identifier == player.identifier }) {
                if question + 1 > self.judgePlayers.count {
                    result.append(player)
                } else if !self.judgePlayers[question].contains(where: { $0.identifier == player.identifier }) {
                    result.append(player)
                }
            }
        }
        return result
    }
    
    public func getInitialCriterias() -> [PartyCriteria] {
        var initialArray: [PartyCriteria] = self.criterias
        if self.criterias.count >= 3 {
            initialArray = Array(self.criterias.prefix(3))
            self.criterias.removeFirst(3)
        }
        
        return initialArray
    }
    
    public func pullANewCriteria(criteria: PartyCriteria) -> PartyCriteria? {
        if !self.criterias.isEmpty {
            return  self.criterias.removeFirst()
        }
        return nil
    }
}
