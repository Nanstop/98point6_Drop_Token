//
//  DropToken98Point6Tests.swift
//  DropToken98Point6Tests
//
//  Created by Nan Shan on 11/20/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import XCTest
@testable import DropToken98Point6

class DropToken98Point6Tests: XCTestCase {
    
    // API test
    func testNextMoveApiFunction() {
        
        // Make sure end point is current
        XCTAssertEqual(DropTokenApi.endPointUrl, "https://w0ayb2ph1k.execute-api.us-west-2.amazonaws.com/production")
        
        // Make sure function call with valid parameter will return valid data
        let exp = expectation(description: "Calling API")
        let inputParameter : [Int] = []
        DropTokenApi.makeAMoveByAI(inputParameter) {
            returnedMoves in
            if let moves = returnedMoves {
                XCTAssertEqual(moves.count, 1)
                
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    // Services test
    func testInitBoardFUnction() {
        
        // Game should be initially nil
        XCTAssertNil(DropTokenService.game)
        
        // Call init board
        DropTokenService.initBoard(currentMode: .PvAI, size: 4)
        // Verify board is not nil
        XCTAssertTrue(DropTokenService.game?.board != nil)
        // Verify board has 4 rows
        XCTAssertEqual(DropTokenService.game?.board.count, 4)
        for row in DropTokenService.game!.board {
            for cell in row {
                // Verify each cell is empty
                XCTAssertEqual(cell, 0)
            }
        }
    }
    
    func testValidateWinFunction_ShouldWinHorizontally() {
        
        // Create a new game session
        DropTokenService.initBoard(currentMode: .PvP, size: 4)
        let horizontalWinBoard = [[1,1,1,1],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        
        // Empty board will return false
        //XCTAssertFalse(DropTokenService.validateWin(0, 0, 1))
        
        // Test horizontal
        DropTokenService.game?.board = horizontalWinBoard
        XCTAssertTrue(DropTokenService.validateWin(0, 0, 1))
    }
    
    func testValidateWinFunction_ShouldWinVertically() {
        // Create a new game session
        DropTokenService.initBoard(currentMode: .PvP, size: 4)
        let verticalWinBoard = [[1,0,0,0],[1,0,0,0],[1,0,0,0],[1,0,0,0]]
        
        // Test vertical
        DropTokenService.game?.board = verticalWinBoard
        XCTAssertTrue(DropTokenService.validateWin(0, 0, 1))
    }
    
    func testValidateWinFunction_ShouldWinDiagnally_Left() {
        // Create a new game session
        DropTokenService.initBoard(currentMode: .PvP, size: 4)
        let leftDiagnalWinBoard = [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]
        
        // Test vertical
        DropTokenService.game?.board = leftDiagnalWinBoard
        XCTAssertTrue(DropTokenService.validateWin(0, 0, 1))
    }
    
    func testValidateWinFunction_ShouldWinDiagnally_Right() {
        // Create a new game session
        DropTokenService.initBoard(currentMode: .PvP, size: 4)
        let rightDiagnalWinBoard = [[0,0,0,1],[0,0,1,0],[0,1,0,0],[1,0,0,0]]
        
        // Test right diagnal
        DropTokenService.game?.board = rightDiagnalWinBoard
        XCTAssertTrue(DropTokenService.validateWin(3, 0, 1))
    }
    
    func testMakeAMoveFunction() {
        
        // Create a new game session
        DropTokenService.initBoard(currentMode: .PvP, size: 4)
        let winningBoard = [[0,0,0,0],[1,2,0,0],[1,2,0,0],[1,2,0,0]]
        let drawBoard = [[0,1,2,1],[1,2,1,2],[1,2,1,2],[1,2,1,2]]
        let notWinningNorDrawBoard = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        let randomTokenRotationDegree = Int.random(in: -360...360)
        
        // Test valid move
        DropTokenService.game?.currentPlayer = 1
        DropTokenService.game?.board = notWinningNorDrawBoard
        XCTAssertEqual(DropTokenService.makeAMove(0, randomTokenRotationDegree), DropTokenService.MoveResult.Valid)
        
        // Test draw move
        DropTokenService.game?.currentPlayer = 2
        DropTokenService.game?.board = drawBoard
        XCTAssertEqual(DropTokenService.makeAMove(0, randomTokenRotationDegree), DropTokenService.MoveResult.Draw)
        
        // Test winning move
        DropTokenService.game?.currentPlayer = 1
        DropTokenService.game?.board = winningBoard
        XCTAssertEqual(DropTokenService.makeAMove(0, randomTokenRotationDegree), DropTokenService.MoveResult.Win)
    }
}
