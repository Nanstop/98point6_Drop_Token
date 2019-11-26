//
//  DropTokenGame.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/24/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
public class DropTokenGame {
    var board : [[Int]]
    var tokenRotation : [[Int]]
    var apiMoves : [Int]
    var diagnalMap : [Int] = [3,2,1,0]
    var winningCoords : [[Int]] = []
    var currentMode : DropTokenService.GameMode?
    var currentPlayer : Int
    
    init(currentMode: DropTokenService.GameMode) {
        self.apiMoves = []
        self.winningCoords = []
        self.board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        self.tokenRotation = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                board[i][j] = 0
                tokenRotation[i][j] = 0
            }
        }
        self.currentMode = currentMode
        self.currentPlayer = 1
    }
}
