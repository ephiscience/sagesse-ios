//
//  StorageController.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 07/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation


struct CurrentGame: Codable {
    let playersNumber: Int
    let numberOfCards: Int
    let playersNames: [String]?
}

class StorageController {
    private let gameFileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent("Game")
        .appendingPathExtension("plist")
    
    func fetchCurrentGame() -> CurrentGame? {
        guard let data = try? Data(contentsOf: gameFileURL) else {
            return nil
        }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(CurrentGame.self, from: data)
    }
    
    func save(currentGame: CurrentGame) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(currentGame) {
            try? data.write(to: gameFileURL)
        }
    }
}
