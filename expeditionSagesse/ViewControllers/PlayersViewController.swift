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
    var numberOfCriterias : Int = 0
    var players : [Player] = []
    var imageNames = ["horse", "cow", "goose", "lion", "girafe", "elephant"]
    
    let cellHeight = 80
    
    let CellReuseIdentifier = "PlayerTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterPlayersNamesLabel.text = NSLocalizedString("players.choose.name.title", comment: "Enter players name")
        startGameButton.setTitle( NSLocalizedString("button.start.game", comment: "Start the game"), for: .normal)
        
        imageNames.shuffle()
        for i in 0..<playersNumber {
          let player = Player(identifier: i+1, name: nil, imageName: imageNames[i])
            players.append(player)
        }
        
        tableviewHeightConstraint.constant = CGFloat(playersNumber * cellHeight)
        
        self.startGameButton.applyGradient(colors: [Helper.UIColorFromHex(0x02AAB0).cgColor,Helper.UIColorFromHex(0x00CDAC).cgColor])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func startTheGame() {
        if let selectQuestionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllersID.SelectQuestionVC.rawValue) as? SelectQuestionViewController {
            let criterias  = AppConfiguration.getCriteriasCards(numberOfCards: numberOfCriterias)
            let newParty: Party = Party(players: self.players, criterias: criterias)
           
            newParty.setTeams()

            if let questionsSets = getQuestionsSetsFromJson() {
                newParty.questionsSets = randomSelectNQuestionsSets(questionsSets: questionsSets, n: newParty.totalQuestions)
                selectQuestionController.party = newParty
                selectQuestionController.modalPresentationStyle = .fullScreen
                self.present(selectQuestionController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Keyboard Management
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

    private func getQuestionsSetsFromJson() -> [QuestionsSet]? {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    let questionsSets = try decoder.decode([QuestionsSet].self, from: jsonData)
                    return questionsSets
                } catch {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    private func randomSelectNQuestionsSets(questionsSets: [QuestionsSet], n: Int) -> [QuestionsSet] {
        return Array(questionsSets.shuffled().prefix(n))
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
        cell.playerNameTextField.delegate = self
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension PlayersViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let lastPlayerTag = players.last?.identifier
        if textField.tag == lastPlayerTag {
            textField.resignFirstResponder()
            return false
        } else {
           let currentPlayerTag = textField.tag
            let nextCell = tableview.cellForRow(at: IndexPath(row: currentPlayerTag, section: 0)) as? PlayerTableViewCell
            nextCell?.playerNameTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let currentPlayerTag = textField.tag
        let player = players[currentPlayerTag-1]
        player.name = textField.text
        players[currentPlayerTag-1] = player
        
        for i in 0..<playersNumber {
            print("player \(i) : \(players[i].name ?? "" )")
        }
        
        let playersWithName = players.filter( {$0.name != nil && $0.name != "" })
        startGameButton.isEnabled = playersWithName.count == playersNumber
    }
    
}
