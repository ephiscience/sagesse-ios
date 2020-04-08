//
//  ContentView.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 07/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedPlayersNumber = 1
    @State private var selectedDifficultyLevel = 1
    
    var possiblePlayersNumber = [3, 4, 5, 6]
    
    var difficultyLevels = GameSettingsProvider.getDifficultyLevels()
    
    let welcomeMessage = NSLocalizedString("home.welcome.message", comment: "Bienvenue à Expedition Sagesse")
    let chooseNumberUsersMessage = NSLocalizedString("home.choose.playersNumber", comment: "Sélectionnez le nombre de joueurs")
    let chooseDifficultyMessage = NSLocalizedString("home.choose.difficultyLevel", comment: "Choisissez le niveau de difficulté")
    let continueButtonTitle = NSLocalizedString("continue.button", comment: "Continuer")
   
    let cRadius = CGFloat(5.0)
    let cHeight = CGFloat(35)
    
    
    var storageController: StorageController?
    
    var body: some View {
        NavigationView {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    Text(welcomeMessage).padding().font(.title).padding().multilineTextAlignment(TextAlignment.center)
                    Text(chooseNumberUsersMessage)
                    Picker(selection: $selectedPlayersNumber, label: Text("")) {
                        ForEach(0 ..< possiblePlayersNumber.count){
                            Text("\(self.possiblePlayersNumber[$0])")
                        }
                    }.labelsHidden().frame(height: 130)
                }
                 
                Spacer()
                
                VStack {
                Text(chooseDifficultyMessage)
                Picker(selection: $selectedDifficultyLevel, label: Text("")) {
                    ForEach(0 ..< difficultyLevels.count){
                        Text("\(self.difficultyLevels[$0].numberOfCards) (\(self.difficultyLevels[$0].name))")
                    }
                }.labelsHidden().frame(height: 130).padding(.bottom)
                }
                
                Spacer()
                
                
                //Continue button with Navigation link to PlayersView
                var playersView = PlayersView()
                let storageController = StorageController()
                playersView.storageController = storageController
                
                NavigationLink(destination: playersView) {
                    ZStack {
                        RoundedRectangle(cornerRadius: cRadius)
                            .foregroundColor(.white)
                            .opacity(0)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 109/255, green: 58/255, blue: 242/255),Color(red: 57/255, green: 23/255, blue: 189/255)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(cRadius)
                            .frame(height: cHeight)
                            .padding()
                        Text(continueButtonTitle).foregroundColor(.white)
                    }
                  
                }.buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    self.saveCurrentParams()
                })
            }
        }
        }
    }
    
    
    func saveCurrentParams() {
        let playersNumber = possiblePlayersNumber[selectedPlayersNumber]
        let numberOfCards = difficultyLevels[selectedDifficultyLevel].numberOfCards
        let gameParams = CurrentGame(playersNumber:playersNumber, numberOfCards: numberOfCards, playersNames: nil)

        storageController?.save(currentGame: gameParams)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



