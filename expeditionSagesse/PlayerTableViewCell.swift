//
//  PlayerTableViewCell.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 25/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit
class PlayerTableViewCell : UITableViewCell {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerImageView: UIImageView!
    
    override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
        
    }
    
    func configure(withPlayer player: Player) {
        if let imageName = player.imageName {
            playerImageView.image = UIImage(named: imageName)
        }
        
        if let playerName = player.name {
            playerNameTextField.text = playerName
        }
        
        playerNameTextField.placeholder =  String(format:NSLocalizedString("player.name.placeholder", comment: "Player name"), player.identifier)
        playerNameTextField.tag = player.identifier
    }
}
