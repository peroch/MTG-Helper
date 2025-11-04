//
//  GameViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import XCTest
@testable import MTG_Helper

@MainActor
final class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = GameViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Game Creation Tests
    
    func testStartNewGame_Commander() {
        viewModel.startNewGame(format: .commander, playerCount: 4)
        
        XCTAssertNotNil(viewModel.game)
        XCTAssertEqual(viewModel.game?.format, .commander)
        XCTAssertEqual(viewModel.game?.players.count, 4)
        XCTAssertEqual(viewModel.game?.players.first?.life, 40)
        XCTAssertFalse(viewModel.showNewGameSheet)
    }
    
    func testStartNewGame_Standard() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        
        XCTAssertNotNil(viewModel.game)
        XCTAssertEqual(viewModel.game?.format, .standard)
        XCTAssertEqual(viewModel.game?.players.count, 2)
        XCTAssertEqual(viewModel.game?.players.first?.life, 20)
        XCTAssertFalse(viewModel.showNewGameSheet)
    }
    
    
    // MARK: - Life Point Tests
    
    func testAdjustLife_IncreaseLife() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: playerId, by: 5)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 25)
    }
    
    func testAdjustLife_DecreaseLife() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: playerId, by: -7)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 13)
    }
    
    func testAdjustLife_PlayerReachesZeroLife() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: playerId, by: -20)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 0)
        XCTAssertTrue(viewModel.showWinnerAlert)
    }
    
    func testAdjustLife_InvalidPlayerId() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        let initialLife = viewModel.game?.players.first?.life
        
        viewModel.adjustLife(for: UUID(), by: 5)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, initialLife)
    }
    
    func testSetLife_DirectlySetLife() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.setLife(for: playerId, to: 15)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 15)
    }
    
    func testSetLife_SetToZero() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.setLife(for: playerId, to: 0)
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 0)
        XCTAssertTrue(viewModel.showWinnerAlert)
    }
    
    // MARK: - Poison Counter Tests
    
    func testAdjustPoison_IncreasePoison() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustPoison(for: playerId, by: 3)
        
        XCTAssertEqual(viewModel.game?.players.first?.poisonCounters, 3)
    }
    
    func testAdjustPoison_ReachesTenPoison() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustPoison(for: playerId, by: 10)
        
        XCTAssertEqual(viewModel.game?.players.first?.poisonCounters, 10)
        XCTAssertTrue(viewModel.showWinnerAlert)
    }
    
    func testAdjustPoison_CannotGoNegative() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustPoison(for: playerId, by: 5)
        viewModel.adjustPoison(for: playerId, by: -10)
        
        XCTAssertEqual(viewModel.game?.players.first?.poisonCounters, 0)
    }
    
    func testAdjustPoison_InvalidPlayerId() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        
        viewModel.adjustPoison(for: UUID(), by: 5)
        
        XCTAssertEqual(viewModel.game?.players.first?.poisonCounters, 0)
    }
    
    // MARK: - Player Name Tests
    
    func testUpdatePlayerName_Success() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.updatePlayerName(for: playerId, to: "Alice")
        
        XCTAssertEqual(viewModel.game?.players.first?.name, "Alice")
    }
    
    func testUpdatePlayerName_InvalidPlayerId() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        let originalName = viewModel.game?.players.first?.name
        
        viewModel.updatePlayerName(for: UUID(), to: "Bob")
        
        XCTAssertEqual(viewModel.game?.players.first?.name, originalName)
    }
    
    // MARK: - Reset Tests
    
    func testResetAllLife_ResetsToStartingLife() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let player1Id = viewModel.game?.players.first?.id,
              let player2Id = viewModel.game?.players.last?.id else {
            XCTFail("Players not found")
            return
        }
        
        viewModel.adjustLife(for: player1Id, by: -10)
        viewModel.adjustLife(for: player2Id, by: 5)
        viewModel.adjustPoison(for: player1Id, by: 3)
        
        viewModel.resetAllLife()
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 20)
        XCTAssertEqual(viewModel.game?.players.last?.life, 20)
        XCTAssertEqual(viewModel.game?.players.first?.poisonCounters, 0)
    }
    
    func testResetAllLife_CommanderFormat() {
        viewModel.startNewGame(format: .commander, playerCount: 4)
        guard let playerId = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: playerId, by: -20)
        viewModel.resetAllLife()
        
        XCTAssertEqual(viewModel.game?.players.first?.life, 40)
    }
    
    // MARK: - End Game Tests
    
    func testEndGame_ClearsGame() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        viewModel.showWinnerAlert = true
        
        viewModel.endGame()
        
        XCTAssertNil(viewModel.game)
        XCTAssertFalse(viewModel.showWinnerAlert)
    }
    
    // MARK: - Game Over Detection Tests
    
    func testGameOver_OnePlayerAlive() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let player1Id = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: player1Id, by: -20)
        
        XCTAssertTrue(viewModel.game?.isGameOver ?? false)
        XCTAssertTrue(viewModel.showWinnerAlert)
    }
    
    func testGameOver_MultiplePlayersAlive() {
        viewModel.startNewGame(format: .standard, playerCount: 3)
        guard let player1Id = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustLife(for: player1Id, by: -20)
        
        // Two players still alive
        XCTAssertFalse(viewModel.game?.isGameOver ?? true)
        XCTAssertFalse(viewModel.showWinnerAlert)
    }
    
    func testGameOver_PoisonDeath() {
        viewModel.startNewGame(format: .standard, playerCount: 2)
        guard let player1Id = viewModel.game?.players.first?.id else {
            XCTFail("No player found")
            return
        }
        
        viewModel.adjustPoison(for: player1Id, by: 10)
        
        XCTAssertTrue(viewModel.game?.isGameOver ?? false)
        XCTAssertTrue(viewModel.showWinnerAlert)
    }
    
    // MARK: - No Game Tests
    
    func testAdjustLife_NoGame() {
        viewModel.adjustLife(for: UUID(), by: 5)
        
        XCTAssertNil(viewModel.game)
    }
    
    func testSetLife_NoGame() {
        viewModel.setLife(for: UUID(), to: 10)
        
        XCTAssertNil(viewModel.game)
    }
    
    func testAdjustPoison_NoGame() {
        viewModel.adjustPoison(for: UUID(), by: 5)
        
        XCTAssertNil(viewModel.game)
    }
    
    func testUpdatePlayerName_NoGame() {
        viewModel.updatePlayerName(for: UUID(), to: "Test")
        
        XCTAssertNil(viewModel.game)
    }
    
    func testResetAllLife_NoGame() {
        viewModel.resetAllLife()
        
        XCTAssertNil(viewModel.game)
    }
}
