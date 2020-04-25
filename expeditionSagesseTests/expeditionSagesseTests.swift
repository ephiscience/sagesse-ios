//
//  expeditionSagesseTests.swift
//  expeditionSagesseTests
//
//  Created by Karim Lakhssassi on 25/04/2020.
//  Copyright © 2020 ephiscience. All rights reserved.
//

import XCTest
import expeditionSagesse

class expeditionSagesseTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testThreePlayersPartyTeamsSet() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let players: [Player] = [Player(identifier: 0, name: "Omar"), Player(identifier: 1, name: "Karim"), Player(identifier: 2, name: "Pleen")]
        let party: Party = Party(players: players)
        party.setTeams()
        party.talkingPlayers.forEach({ XCTAssert($0.count == 2) })
        party.judgePlayers.forEach({ XCTAssert($0.count == 1) })
    }

    func testFourPlayersPartyTeamsSet() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let players: [Player] = [Player(identifier: 0, name: "Omar"), Player(identifier: 1, name: "Karim"), Player(identifier: 2, name: "Pleen"), Player(identifier: 3, name: "Lili")]
        let party: Party = Party(players: players)
        party.setTeams()
        party.talkingPlayers.forEach({ XCTAssert($0.count == 2) })
        party.judgePlayers.forEach({ XCTAssert($0.count == 2) })
    }

    func testFivePlayersPartyTeamsSet() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let players: [Player] = [Player(identifier: 0, name: "Omar"), Player(identifier: 1, name: "Karim"), Player(identifier: 2, name: "Pleen"), Player(identifier: 3, name: "Lili"), Player(identifier: 4, name: "Julien")]
        let party: Party = Party(players: players)
        party.setTeams()
        party.talkingPlayers.forEach({ XCTAssert($0.count == 2) })
        party.judgePlayers.forEach({ XCTAssert($0.count == 3) })
    }

    func testSixPlayersPartyTeamsSet() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let players: [Player] = [Player(identifier: 0, name: "Omar"), Player(identifier: 1, name: "Karim"), Player(identifier: 2, name: "Pleen"), Player(identifier: 3, name: "Lili"), Player(identifier: 4, name: "Julien"), Player(identifier: 5, name: "Matthieu")]
        let party: Party = Party(players: players)
        party.setTeams()
        party.talkingPlayers.forEach({ XCTAssert($0.count == 2) })
        party.judgePlayers.forEach({ XCTAssert($0.count == 4) })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
