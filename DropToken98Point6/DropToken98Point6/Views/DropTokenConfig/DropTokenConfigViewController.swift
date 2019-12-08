//
//  DropTokenConfigViewController.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/24/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import UIKit

class DropTokenConfigViewController: UIViewController {
    var imagePicker : UIImagePickerController!
    var selectedCustomToken : Int = 0
    var playerCustomTokenImages : [UIImage?] = [nil, nil]
    @IBOutlet weak var PlayerOneView: UIView!
    @IBOutlet weak var PlayerTwoView: UIView!
    @IBOutlet weak var PlayerOneNameTextField: UITextField!
    
    @IBOutlet weak var PlayerTwoNameTextField: UITextField!
    
    @IBOutlet weak var PlayerOneRoleSwitch: UISegmentedControl!
    @IBOutlet weak var PlayerTwoRoleSwitch: UISegmentedControl!
    @IBOutlet weak var PlayerOneClassicTokenBtn: UIButton!
    @IBAction func PlayerOneClassicTokenBtnPressed(_ sender: UIButton) {
        sender.isSelected = true
        PlayerOneCustomTokenBtn.isSelected = false
    }
    @IBOutlet weak var PlayerOneCustomTokenBtn: UIButton!
    @IBAction func PlayerOneCustomTokenBtnPressed(_ sender: UIButton) {
        selectedCustomToken = 1
        self.present(imagePicker, animated: true) {
            sender.isSelected = true
            self.PlayerOneClassicTokenBtn.isSelected = false
        }
    }
    @IBOutlet weak var PlayerTwoClassicTokenBtn: UIButton!
    @IBAction func PlayerTwoClassicTokenBtnPressed(_ sender: UIButton) {
        sender.isSelected = true
        PlayerTwoCustomTokenBtn.isSelected = false
    }
    
    @IBOutlet weak var PlayerTwoCustomTokenBtn: UIButton!
    @IBAction func PlayerTwoCustomTokenBtnPressed(_ sender: UIButton) {
        selectedCustomToken = 2
        self.present(imagePicker, animated: true) {
            sender.isSelected = true
            self.PlayerTwoClassicTokenBtn.isSelected = false
        }
    }
    
    @IBOutlet weak var StartGameBtn: UIButton!
    @IBAction func StartGameBtnPressed(_ sender: UIButton) {
        // Create Game
        guard let playerOneName = PlayerOneNameTextField.text else { return }
        guard let playerTwoName = PlayerTwoNameTextField.text else { return }
        let playerOneRole = PlayerOneRoleSwitch.selectedSegmentIndex == 0 ? DropTokenService.playerType.human : .computer
        let playerTwoRole = PlayerTwoRoleSwitch.selectedSegmentIndex == 0 ? DropTokenService.playerType.human : .computer
        let playerOne = Player.init(id: 1, name: playerOneName, type: playerOneRole)
        let playerTwo = Player.init(id: 2, name: playerTwoName, type: playerTwoRole)
        if PlayerOneCustomTokenBtn.isSelected == true {
            playerOne.tokenImage = playerCustomTokenImages[0]
        }
        if PlayerTwoCustomTokenBtn.isSelected == true {
            playerTwo.tokenImage = playerCustomTokenImages[1]
        }
        let currentMode = playerOneRole == .computer || playerTwoRole == .computer ? DropTokenService.GameMode.PvAI : .PvP
        DropTokenService.initBoard(currentMode: currentMode)
        DropTokenService.players = [playerOne, playerTwo]
        self.performSegue(withIdentifier: "goToDropTokenViewSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        updateUIComponents()
        hideKeyboardWhenTappedAround()
    }
    
    func updateUIComponents() {
        PlayerOneView.layer.cornerRadius = 14
        PlayerOneView.layer.borderWidth = 1
        PlayerOneView.layer.borderColor = UIColor.gray.cgColor
        
        PlayerTwoView.layer.cornerRadius = 14
        PlayerTwoView.layer.borderWidth = 1
        PlayerTwoView.layer.borderColor = UIColor.gray.cgColor
        
        PlayerOneClassicTokenBtn.backgroundColor = UIColor.red
        PlayerOneClassicTokenBtn.layer.cornerRadius = 32.5
        
        PlayerOneCustomTokenBtn.layer.borderColor = UIColor.red.cgColor
        PlayerOneCustomTokenBtn.layer.borderWidth = 1
        PlayerOneCustomTokenBtn.layer.cornerRadius = 32.5
        
        PlayerTwoClassicTokenBtn.backgroundColor = UIColor.blue
        PlayerTwoClassicTokenBtn.layer.cornerRadius = 32.5
        
        PlayerTwoCustomTokenBtn.layer.borderColor = UIColor.blue.cgColor
        PlayerTwoCustomTokenBtn.layer.borderWidth = 1
        PlayerTwoCustomTokenBtn.layer.cornerRadius = 32.5
        
        StartGameBtn.layer.cornerRadius = 24
        
    }
}
