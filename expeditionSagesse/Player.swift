//
//  PlayersUtils.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation

public class Player {
    var identifier: Int
    var name: String

    public init(identifier: Int, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
