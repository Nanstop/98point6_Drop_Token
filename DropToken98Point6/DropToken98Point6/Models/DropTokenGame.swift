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
    var winningCoords : [[Int]] = []
    var currentMode : DropTokenService.GameMode?
    var currentPlayer : Int
    var size: Int
    
    init(currentMode: DropTokenService.GameMode, size: Int) {
        self.apiMoves = []
        self.winningCoords = []
        self.board = Array(repeating: Array(repeating: 0, count: size), count: size)
        self.tokenRotation = Array(repeating: Array(repeating: 0, count: size), count: size)
        for i in 0 ..< size {
            for j in 0 ..< size {
                board[i][j] = 0
                tokenRotation[i][j] = 0
            }
        }
        self.currentMode = currentMode
        self.currentPlayer = 1
        self.size = size
    }
}
