//
//  PlayersUtils.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

 public class Player {
    var identifier: Int
    var name: String?
    var imageName: String {
        didSet {
            avatar = UIImage(named: imageName)
        }
    }
    var avatar: UIImage?


    public init(identifier: Int, name: String?, imageName: String? = "lion") {
        self.identifier = identifier
        self.name = name
        self.imageName = "lion"
        defer {
            if let _imageName = imageName {
                self.imageName = _imageName
            }
        }
    }
}
