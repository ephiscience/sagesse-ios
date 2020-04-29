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

class AppConfiguration {
    
    static func getDifficultyLevels() -> [DifficultyLevel] {
        
        let easy  = DifficultyLevel(name: NSLocalizedString("difficulty.level.easy", comment: "easy"), numberOfCards: 12)
        let middle  = DifficultyLevel(name: NSLocalizedString("difficulty.level.middle", comment: "middle"), numberOfCards: 24)
        let hard  = DifficultyLevel(name: NSLocalizedString("difficulty.level.hard", comment: "hard"), numberOfCards: 36)
        return [easy, middle, hard]
    }
}
