//
//  DropTokenConfigViewController.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/24/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import UIKit

class DropTokenConfigViewController: UIViewController {


    @IBOutlet weak var PlayerOneNameTextField: UITextField!
    
    @IBOutlet weak var PlayerTwoNameTextField: UITextField!
    
    @IBOutlet weak var PlayerOneRoleSwitch: UISegmentedControl!
    @IBOutlet weak var PlayerTwoRoleSwitch: UISegmentedControl!
    @IBOutlet weak var StartGameBtn: UIButton!
    @IBAction func StartGameBtnPressed(_ sender: UIButton) {
        // Create Game
        guard let playerOneName = PlayerOneNameTextField.text else { return }
        guard let playerTwoName = PlayerTwoNameTextField.text else { return }
        let playerOneRole = PlayerOneRoleSwitch.selectedSegmentIndex == 1 ? DropTokenService.playerType.human : .computer
        let playerTwoRole = PlayerTwoRoleSwitch.selectedSegmentIndex == 1 ? DropTokenService.playerType.human : .computer
        let playerOne = Player.init(id: 1, name: playerOneName, type: playerOneRole)
        let playerTwo = Player.init(id: 2, name: playerTwoName, type: playerTwoRole)
        let currentMode = playerOneRole == .computer || playerTwoRole == .computer ? DropTokenService.GameMode.PvAI : .PvP
        DropTokenService.initBoard(currentMode: currentMode)
        DropTokenService.players = [playerOne, playerTwo]
        self.performSegue(withIdentifier: "goToDropTokenViewSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIComponents()
        hideKeyboardWhenTappedAround()
    }
    
    func updateUIComponents() {
        
    }
}
