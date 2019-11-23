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
    public static var apiMoves : [Int] = []
    public static var diagnalMap : [Int] = [3,2,1,0]
    public enum moveResult {
        case Valid, Invalid, Win, Draw
    }
    
    public static func initBoard() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                board[i][j] = 0
            }
        }
    }
    
    public static func validateWin(_ x: Int, _ y: Int, _ currentPlayer: Int) -> Bool{
        var result = true
        // check horizontal
        for i in 0...3 {
            if board[i][y] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
        }
        // check vertical
        for j in 0...3 {
            if board[x][j] != currentPlayer {
                result = false
                break
            }
        }
        if result == true {
            return result
        } else {
            result = true
        }
        // check diagnal
        if x == y {
            for i in 0...3 {
                if board[i][i] != currentPlayer {
                    result = false
                    break
                }
            }
        } else if x == 3 - y {
            for j in 0...3 {
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
        switch cellValue {
        case 1:
            return UIColor.red
        case 2:
            return UIColor.blue
        default:
            return UIColor.white
        }
    }
    
    public static func makeAMove(_ nextMove: Int, _ currentPlayer: Int) -> moveResult {
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
                moveMade = true
                if validateWin(i, nextMove, currentPlayer) {
                    return .Win
                }
            }
        }
        if moveMade == false {
            return .Draw
        } else {
            return .Valid
        }
    }
    
    public static func isColumnAvailable(_ colIndex: Int) -> Bool {
        return board[0][colIndex] == 0
    }
}
