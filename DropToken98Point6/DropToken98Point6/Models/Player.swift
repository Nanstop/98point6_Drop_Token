//
//  Player.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/24/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
import UIKit

public class Player {
    var id : Int
    var name : String
    var type : DropTokenService.playerType
    var tokenImage : UIImage?
    var winnings : Int
    
    init(id: Int, name: String, type: DropTokenService.playerType) {
        self.id = id
        self.name = name
        self.type = type
        self.tokenImage = nil
        self.winnings = 0
    }
}
