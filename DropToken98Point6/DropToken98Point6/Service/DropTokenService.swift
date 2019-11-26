//
//  DropTokenService.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
import UIKit

public class DropTokenService {
    public static var game: DropTokenGame? = nil
    public static var players : [Player] = []
    public enum GameMode {
        case PvP, PvAI
    }
    public enum MoveResult {
        case Valid, Invalid, Win, Draw
    }
    enum playerType {
        case human, computer
    }
    public static func initBoard(currentMode: GameMode) {
        game = DropTokenGame.init(currentMode: currentMode)
    }
    
    public static func validateWin(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        guard let currentGame = game else { return false }
        var result = true
        currentGame.winningCoords = []
        // check horizontal
        for i in 0...3 {
            currentGame.winningCoords.append([i,y])
            if currentGame.board[i][y] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
            currentGame.winningCoords = []
        }
        // check vertical
        for j in 0...3 {
            currentGame.winningCoords.append([x,j])
            if currentGame.board[x][j] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
            currentGame.winningCoords = []
        }
        // check diagnal
        if x == y {
            for i in 0...3 {
                currentGame.winningCoords.append([i,i])
                if currentGame.board[i][i] != currentPlayer {
                    result = false
                    break
                }
            }
        } else if x == 3 - y {
            for j in 0...3 {
                currentGame.winningCoords.append([j,currentGame.diagnalMap[j]])
                if currentGame.board[j][currentGame.diagnalMap[j]] != currentPlayer {
                    result = false
                    break
                }
            }
        } else {
            result = false
        }
        return result
    }
    
    public static func decideCellColor(_ x: Int, _ y: Int) -> UIColor {
        guard let currentGame = game else { return decideCellColorByPlayerId(0) }
        let cellValue = currentGame.board[x][y]
        return decideCellColorByPlayerId(cellValue)
    }
    
    public static func decideCellColorByPlayerId(_ id: Int) -> UIColor {
        switch id {
        case 1:
            return UIColor.red
        case 2:
            return UIColor.blue
        default:
            return UIColor.white
        }
    }
    
    public static func decideCellImage(_ x: Int, _ y: Int) -> UIImage? {
        guard let currentGame = game else { return nil }
        let cellValue = currentGame.board[x][y]
        return decideCellImageByPlayerId(cellValue)
    }
    
    public static func decideCellImageByPlayerId(_ id: Int) -> UIImage? {
        if id == 1 {
            if let imageData = UserDefaults.standard.data(forKey: "playerOneProfile") {
                return UIImage(data: imageData)
            }
        } else if id == 2 {
            if let imageData = UserDefaults.standard.data(forKey: "playerTwoProfile") {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    public static func makeAMove(_ nextMove: Int, _ tokenRotationDegree: Int) -> MoveResult {
        guard let currentGame = game else { return .Invalid }
        var moveMade = false
        if currentGame.board[0][nextMove] != 0 {
            return .Invalid
        }
        for i in (0...3).reversed() {
            if moveMade == true {
                break
            }
            if currentGame.board[i][nextMove] == 0 {
                currentGame.board[i][nextMove] = currentGame.currentPlayer
                currentGame.tokenRotation[i][nextMove] = tokenRotationDegree
                currentGame.apiMoves.append(nextMove)
                if validateWin(i, nextMove, currentGame.currentPlayer) {
                    return .Win
                }
                currentGame.currentPlayer = currentGame.currentPlayer == 1 ? 2 : 1
                moveMade = true
            }
        }
        if isDraw() == true {
            return .Draw
        } else {
            return .Valid
        }
    }
    
    private static func isDraw() -> Bool {
        guard let currentGame = game else { return false }
        for i in 0...3 {
            if currentGame.board[0][i] == 0 {
                return false
            }
        }
        return true
    }
    
    public static func isColumnAvailable(_ colIndex: Int) -> Bool {
        guard let currentGame = game else { return false }
        return currentGame.board[0][colIndex] == 0
    }
    
    public static func shouldHighlightCell(_ x: Int, _ y: Int) -> Bool {
        guard let currentGame = game else { return false }
        return currentGame.winningCoords.contains([x,y])
    }
    
    public static func getWinnerString() -> String {
        guard let currentGame = game else { return "" }
        let winner = players[currentGame.currentPlayer - 1]
        return winner.name + " WINS!"
    }
    
    public static func isComputerNext() -> Bool? {
        guard let currentGame = game else { return nil }
        let currentPlayer = players[currentGame.currentPlayer - 1]
        return currentPlayer.type == .computer
    }
    
    public static func reset() {
        guard let currentGame = game else { return }
        game = DropTokenGame.init(currentMode: currentGame.currentMode!)
    }
}
