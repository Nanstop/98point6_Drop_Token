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
    public static var board : [[Int]] = []
    public static var tokenRotation : [[Int]] = []
    public static var apiMoves : [Int] = []
    public static var diagnalMap : [Int] = [3,2,1,0]
    public static var winningCoords : [[Int]] = []
    public enum moveResult {
        case Valid, Invalid, Win, Draw
    }
    
    public static func initBoard() {
        apiMoves = []
        winningCoords = []
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        tokenRotation = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                board[i][j] = 0
                tokenRotation[i][j] = 0
            }
        }
    }
    
    public static func validateWin(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool {
        var result = true
        winningCoords = []
        // check horizontal
        for i in 0...3 {
            winningCoords.append([i,y])
            if board[i][y] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
            winningCoords = []
        }
        // check vertical
        for j in 0...3 {
            winningCoords.append([x,j])
            if board[x][j] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
            winningCoords = []
        }
        // check diagnal
        if x == y {
            for i in 0...3 {
                winningCoords.append([i,i])
                if board[i][i] != currentPlayer {
                    result = false
                    break
                }
            }
        } else if x == 3 - y {
            for j in 0...3 {
                winningCoords.append([j,diagnalMap[j]])
                if board[j][diagnalMap[j]] != currentPlayer {
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
        let cellValue = board[x][y]
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
        let cellValue = board[x][y]
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
    
    public static func makeAMove(_ nextMove: Int, _ currentPlayer: Int, _ tokenRotationDegree: Int) -> moveResult {
        var moveMade = false
        if board[0][nextMove] != 0 {
            return .Invalid
        }
        for i in (0...3).reversed() {
            if moveMade == true {
                break
            }
            if board[i][nextMove] == 0 {
                board[i][nextMove] = currentPlayer
                tokenRotation[i][nextMove] = tokenRotationDegree
                apiMoves.append(nextMove)
                moveMade = true
                if validateWin(i, nextMove, currentPlayer) {
                    return .Win
                }
            }
        }
        if isDraw() == true {
            return .Draw
        } else {
            return .Valid
        }
    }
    
    private static func isDraw() -> Bool {
        for i in 0...3 {
            if board[0][i] == 0 {
                return false
            }
        }
        return true
    }
    
    public static func isColumnAvailable(_ colIndex: Int) -> Bool {
        return board[0][colIndex] == 0
    }
    
    public static func shouldHighlightCell(_ x: Int, _ y: Int) -> Bool {
        return winningCoords.contains([x,y])
    }
}
