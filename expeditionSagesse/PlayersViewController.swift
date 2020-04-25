//
//  PlayersViewController.swift
//  expeditionSagesseStoryboard
//
//  Created by Omar Mahboubi on 24/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import Foundation
import UIKit

class PlayersViewController: UIViewController {
    
  @IBOutlet weak var enterPlayersNamesLabel: UILabel!
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var startGameButton: UIButton!
    
    var playersNumber : Int = 0
    var players : [Player] = []
    let imageNames = ["horse", "cow", "goose", "lion", "girafe", "elephant"]
    
    let CellReuseIdentifier = "PlayerTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterPlayersNamesLabel.text = NSLocalizedString("players.choose.name.title", comment: "Enter players name")
        startGameButton.setTitle( NSLocalizedString("button.start.game", comment: "Start the game"), for: .normal)
        
        for i in 0..<playersNumber {
          let player = Player(identifier: i+1, name: nil, imageName: imageNames[i])
            players.append(player)
        }
    }
}


extension PlayersViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
           
           return playersNumber
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath) as! PlayerTableViewCell
        let player = players[indexPath.row]
        cell.configure(withPlayer: player)
        
        
        return cell
    }
}
