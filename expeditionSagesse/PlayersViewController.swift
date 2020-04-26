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
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var enterPlayersNamesLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    var playersNumber : Int = 0
    var players : [Player] = []
    let imageNames = ["horse", "cow", "goose", "lion", "girafe", "elephant"]
    
    let cellHeight = 80
    
    let CellReuseIdentifier = "PlayerTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterPlayersNamesLabel.text = NSLocalizedString("players.choose.name.title", comment: "Enter players name")
        startGameButton.setTitle( NSLocalizedString("button.start.game", comment: "Start the game"), for: .normal)
        
        for i in 0..<playersNumber {
          let player = Player(identifier: i+1, name: nil, imageName: imageNames[i])
            players.append(player)
        }
        
        tableviewHeightConstraint.constant = CGFloat(playersNumber * cellHeight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollview.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollview.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollview.contentInset = contentInset
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

extension PlayersViewController : UITextFieldDelegate {
    
}
