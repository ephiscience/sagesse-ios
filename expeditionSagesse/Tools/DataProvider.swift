//
//  DataProvider.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 02/05/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation

struct DifficultyLevel {
    var name: String
    var numberOfCards: Int
}


class DataProvider  {
    
    static func getDifficultyLevels() -> [DifficultyLevel] {
        let easy  = DifficultyLevel(name: NSLocalizedString("difficulty.level.easy", comment: "easy"), numberOfCards: 12)
        let middle  = DifficultyLevel(name: NSLocalizedString("difficulty.level.middle", comment: "middle"), numberOfCards: 24)
        let hard  = DifficultyLevel(name: NSLocalizedString("difficulty.level.hard", comment: "hard"), numberOfCards: 36)
        return [easy, middle, hard]
    }
    
    
    static func getCriteriasCards(numberOfCards: Int) -> [PartyCriteria] {
         var criteriasCards : [PartyCriteria] = []

        if let filepath = Bundle.main.path(forResource: "criterias", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath:filepath), options: .mappedIfSafe)
                let criterias = try! JSONDecoder().decode([GameCriteria].self, from: data)
                var basicCriterias: [String] = []
                
                let userLanguage = AppConfiguration.getUserLanguageCode()
                
                //Select List of basic criterias with the user's language
                for criteria in criterias {
                    if let localizedCriteria = criteria.labels[userLanguage.rawValue] {
                        basicCriterias.append(localizedCriteria)
                    }
                }
                
               //create random array of criterias with numberOfCards size
                for _ in 0..<numberOfCards {
                    let randomCriteria = basicCriterias.randomElement()!
                    let partyCriteria = PartyCriteria(title: randomCriteria, validatedAuditors: 0)
                    criteriasCards.append(partyCriteria)
                }
                print(criteriasCards)
                
            } catch {
                // contents could not be loaded
            }
        }
        return criteriasCards
    }

    static private func getQuestionsSetsFromJson() -> [QuestionsSet]? {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    let questionsSets = try decoder.decode([QuestionsSet].self, from: jsonData)
                    return questionsSets
                } catch {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static private func randomSelectNQuestionsSets(questionsSets: [QuestionsSet], n: Int) -> [QuestionsSet] {
        return Array(questionsSets.shuffled().prefix(n))
    }
    
    
    static func getRandomQuestions(numberOfQuestions: Int) -> [QuestionsSet]? {
        var randomQuestions : [QuestionsSet]?
        if let allQuestionsSets = DataProvider.getQuestionsSetsFromJson() {
            randomQuestions = DataProvider.randomSelectNQuestionsSets(questionsSets: allQuestionsSets, n: numberOfQuestions)
        }
        return randomQuestions
    }
}
