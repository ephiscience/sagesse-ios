//
//  ContentView.swift
//  expeditionSagesse
//
//  Created by Omar Mahboubi on 07/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import SwiftUI


class GameParamsViewModel : ObservableObject {
    @Published var welcomeMessage = NSLocalizedString("home.welcome.message", comment: "Bienvenue à Expedition Sagesse")
    @Published var chooseNumberUsersMessage = NSLocalizedString("home.choose.playersNumber", comment: "Sélectionnez le nombre de joueurs")
    @Published var chooseDifficultyMessage = NSLocalizedString("home.choose.difficultyLevel", comment: "Choisissez le niveau de difficulté")
    @Published var continueButtonTitle = NSLocalizedString("continue.button", comment: "Continuer")
    @Published var possiblePlayersNumber : [Int] = [3, 4, 5, 6]
    
    var difficultyLevels = GameSettingsProvider.getDifficultyLevels()
    var storageController = StorageController()
    
    @State var selectedPlayersNumber = 1
    @State var selectedDifficultyLevel = 1
    
     func saveCurrentParams() {
        let playersNumber = possiblePlayersNumber[selectedPlayersNumber]
        let numberOfCards = difficultyLevels[selectedDifficultyLevel].numberOfCards
        let gameParams = CurrentGame(playersNumber:playersNumber, numberOfCards: numberOfCards, playersNames: nil)

        storageController.save(currentGame: gameParams)
        
    }
    
}

struct ContentView: View {
    
    @ObservedObject var viewModel : GameParamsViewModel = GameParamsViewModel()


    let cRadius = CGFloat(5.0)
    let cHeight = CGFloat(35)
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        Text(viewModel.welcomeMessage).padding().font(.title).padding().multilineTextAlignment(TextAlignment.center)
                        Text(viewModel.chooseNumberUsersMessage)
                        Picker(selection: $viewModel.selectedPlayersNumber, label: Text("")) {
                            ForEach(0 ..< viewModel.possiblePlayersNumber.count ){
                                Text("\(self.viewModel.possiblePlayersNumber[$0])")
                            }
                        }.labelsHidden().frame(height: 130)
                        
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(viewModel.chooseDifficultyMessage)
                        Picker(selection: $viewModel.selectedDifficultyLevel, label: Text("")) {
                            ForEach(0 ..< viewModel.difficultyLevels.count){
                                Text("\(self.viewModel.difficultyLevels[$0].numberOfCards) (\(self.viewModel.difficultyLevels[$0].name))")
                            }
                        }.labelsHidden().frame(height: 130).padding(.bottom)
                    }
                    
                    Spacer()
                    
                   
                    //Continue button with Navigation link to PlayersView
                    NavigationLink(destination: PlayersView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: cRadius)
                                .foregroundColor(.white)
                                .opacity(0)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 109/255, green: 58/255, blue: 242/255),Color(red: 57/255, green: 23/255, blue: 189/255)]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(cRadius)
                                .frame(height: cHeight)
                                .padding()
                            Text(viewModel.continueButtonTitle).foregroundColor(.white)
                        }

                    }.buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded {
                            self.viewModel.saveCurrentParams()
                        })
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



