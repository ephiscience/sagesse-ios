//
//  PlayerView.swift
//  expeditionSagesse
//
//  Created by Karim Lakhssassi on 25/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

public class PlayerView: UIView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!

    public func configure(playerName: String, playerAvatar: UIImage) {
        avatarImageView.image = playerAvatar
        playerNameLabel.text = playerName
    }
}
