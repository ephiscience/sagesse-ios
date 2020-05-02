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
    case QuestionTurnVC = "QuestionTurnViewControllerID"
}

public enum SegueIdentifier: String {
    case ChoosePlayersNamesSegue = "ChoosePlayersNamesSegue"
}


enum SupportedLanguage : String {
    case fr = "FR"
    case en = "EN"
}

class AppConfiguration {
    
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
