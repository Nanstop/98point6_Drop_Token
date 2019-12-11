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
    public static func initBoard(currentMode: GameMode, size: Int) {
        game = DropTokenGame.init(currentMode: currentMode, size: size)
    }
    
    public static func validateWin(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        
        return validateHorizontal(x, y, currentPlayer) ? true : validateVertical(x, y, currentPlayer) ? true : validateDiagnal(x, y, currentPlayer)
    }
    
    private static func validateHorizontal(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        guard let currentGame = game else { return false }
        currentGame.winningCoords = []
        
        // check left and right from given coord to see if there are 4
        for i in (0 ..< x).reversed() {
            if currentGame.board[i][y] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,y])
            }
        }
        if currentGame.winningCoords.count >= 3 {
            return true
        }
        for i in x ..< currentGame.size {
            if currentGame.board[i][y] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,y])
            }
        }
        return currentGame.winningCoords.count >= 4
    }
    
    private static func validateVertical(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        guard let currentGame = game else { return false }
        currentGame.winningCoords = []
        
        // check top and down from given coord to see if there are 4
        for j in (0 ..< y).reversed() {
            if currentGame.board[x][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([x,j])
            }
        }
        if currentGame.winningCoords.count >= 3 {
            return true
        }
        for j in y ..< currentGame.size {
            if currentGame.board[x][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([x,j])
            }
        }
        return currentGame.winningCoords.count >= 4
    }
    
    private static func validateDiagnal(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        return validateLeftDiagnal(x, y, currentPlayer) ? true : validateRightDiagnal(x, y, currentPlayer)
    }
    
    private static func validateLeftDiagnal(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        guard let currentGame = game else { return false }
        currentGame.winningCoords = []
        // validate left diagnal by checking top-left and bottom-right
        var i = x, j = y;
        while i >= 0 && i < currentGame.size && j >= 0 && j < currentGame.size {
            if currentGame.board[i][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,j])
            }
            i -= 1
            j -= 1
        }
        if currentGame.winningCoords.count >= 4 {
            return true
        }
        
        i = x + 1
        j = y + 1
        while i >= 0 && i < currentGame.size && j >= 0 && j < currentGame.size {
            if currentGame.board[i][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,j])
            }
            i += 1
            j += 1
        }
        return currentGame.winningCoords.count >= 4
    }
    
    private static func validateRightDiagnal(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        guard let currentGame = game else { return false }
        currentGame.winningCoords = []
        // validate right diagnal by checking top-right and bottom-left
        var i = x, j = y;
        while i >= 0 && i < currentGame.size && j >= 0 && j < currentGame.size {
            if currentGame.board[i][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,j])
            }
            i += 1
            j -= 1
        }
        if currentGame.winningCoords.count >= 4 {
            return true
        }
        
        i = x - 1
        j = y + 1
        while i >= 0 && i < currentGame.size && j >= 0 && j < currentGame.size {
            if currentGame.board[i][j] != currentPlayer {
                break
            } else {
                currentGame.winningCoords.append([i,j])
            }
            i -= 1
            j += 1
        }
        return currentGame.winningCoords.count >= 4
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
        if id == 0 || players.count == 0 || id > players.count {
            return nil
        }
        if let image = players[id - 1].tokenImage {
            return image
        }
        return nil
    }
    
    public static func makeAMove(_ nextMove: Int, _ tokenRotationDegree: Int) -> MoveResult {
        guard let currentGame = game else { return .Invalid }
        var moveMade = false
        if currentGame.board[0][nextMove] != 0 {
            return .Invalid
        }
        for i in (0 ..< currentGame.size).reversed() {
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
            currentGame.winningCoords = []
            return .Draw
        } else {
            return .Valid
        }
    }
    
    private static func isDraw() -> Bool {
        guard let currentGame = game else { return false }
        for i in 0 ..< currentGame.size {
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
        game = DropTokenGame.init(currentMode: currentGame.currentMode!, size: currentGame.size)
    }
    
    public static func getPlayerImage() -> UIImage? {
        guard let currentGame = game else { return nil }
        return players[currentGame.currentPlayer - 1].tokenImage
    }
    
    public static func getPlayerColor() -> UIColor {
        guard let currentGame = game else { fatalError() }
        return currentGame.currentPlayer == 1 ? UIColor.red : UIColor.blue
    }
}
