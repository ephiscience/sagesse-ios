//
//  AppConfiguration.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 25/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

public enum ViewControllersID: String {
    case SelectQuestionVC = "SelectQuestionViewControllerID"
}

public enum SegueIdentifier: String {
    case ChoosePlayersNamesSegue = "ChoosePlayersNamesSegue"
}

struct DifficultyLevel {
    var name: String
    var numberOfCards: Int
}

enum SupportedLanguage : String {
    case fr = "FR"
    case en = "EN"
}
class AppConfiguration {
    
    static func getDifficultyLevels() -> [DifficultyLevel] {
        
        let easy  = DifficultyLevel(name: NSLocalizedString("difficulty.level.easy", comment: "easy"), numberOfCards: 12)
        let middle  = DifficultyLevel(name: NSLocalizedString("difficulty.level.middle", comment: "middle"), numberOfCards: 24)
        let hard  = DifficultyLevel(name: NSLocalizedString("difficulty.level.hard", comment: "hard"), numberOfCards: 36)
        return [easy, middle, hard]
    }
    
    enum GameCriteriaTypes : String {
        case giveReason = "criteria.give.reason"
        case define =  "criteria.define"
        case example = "criteria.example"
    }
    
    class GameCriteria : Codable {
        var identifier: String
        var labels: [String:String]
    }
    
    
    static func getCriteriasCards(numberOfCards: Int) -> [String] {
         var criteriasCards : [String] = []

        if let filepath = Bundle.main.path(forResource: "criterias", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath:filepath), options: .mappedIfSafe)
                let criterias = try! JSONDecoder().decode([GameCriteria].self, from: data)
                var basicCriterias: [String] = []
                
                let userLanguage = AppConfiguration.getUserLanguageCode()
                
                for criteria in criterias {
                    if let localizedCriteria = criteria.labels[userLanguage.rawValue] {
                        basicCriterias.append(localizedCriteria)
                    }
                }
                
               
                for _ in 0..<numberOfCards {
                    criteriasCards.append(basicCriterias.randomElement()!)
                }
                print(criteriasCards)
                
            } catch {
                // contents could not be loaded
            }
        }
        return criteriasCards
    }

    
    static func getUserLanguageCode() -> SupportedLanguage {
        let langStr = Locale.current.languageCode
        
        switch langStr {
        case "fr":
            return .fr
        case "en":
            return .en
        default:
            return .fr
        }
    }
}
