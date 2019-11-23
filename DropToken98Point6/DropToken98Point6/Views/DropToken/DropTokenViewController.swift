//
//  ViewController.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/20/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import UIKit

class DropTokenViewController: UIViewController {
    // State var within view controller
    var currentPlayer : Int = 1 {
        didSet {
            ResultLabel.text = "Player " + String(currentPlayer) + "'s turn"
        }
    }
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBAction func ResetBtnPressed(_ sender: UIButton) {
        initBoard()
    }

    @IBOutlet weak var DropTokenCollection: UICollectionView!
    @IBOutlet weak var ColOneBtn: UIButton!
    @IBAction func ColOneBtnPressed(_ sender: UIButton) {
        makeAMove(0)
    }
    
    @IBOutlet weak var ColTwoBtn: UIButton!
    @IBAction func ColTwoBtnPressed(_ sender: UIButton) {
        makeAMove(1)
    }
    
    @IBOutlet weak var ColThreeBtn: UIButton!
    @IBAction func ColThreeBtnPressed(_ sender: UIButton) {
        makeAMove(2)
    }
    
    @IBOutlet weak var ColFourBtn: UIButton!
    @IBAction func ColFourBtnPressed(_ sender: UIButton) {
        makeAMove(3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        // Do any additional setup after loading the view.
        DropTokenCollection.backgroundColor = UIColor.lightGray
    }
    
    func initBoard() {
        DropTokenService.initBoard()
        currentPlayer = 1
        toggleBtns(false)
        DispatchQueue.main.async(execute: {
           self.DropTokenCollection.reloadData()
        })
    }
    
    // Call API to get next move
    func makeAMove(_ nextMove: Int) {
        let result = DropTokenService.makeAMove(nextMove, currentPlayer)
        // Update board UI
        DispatchQueue.main.async(execute: {
            self.DropTokenCollection.reloadData()
        })
        switch result {
        case .Valid:
            if !DropTokenService.isColumnAvailable(nextMove) {
                disableCurrentColumn(nextMove)
            }
            currentPlayer = currentPlayer == 1 ? 2 : 1
        case .Win:
            ResultLabel.text = "Player " + String(currentPlayer) + " WINS!"
            toggleBtns(true)
        case .Draw:
            ResultLabel.text = "Draw!"
            toggleBtns(true)
        default:
            ResultLabel.text = "Invalid move, please try again"
        }
    }
    
    func disableCurrentColumn(_ col: Int) {
        switch col {
            case 0:
                ColOneBtn.isHidden = true
            case 1:
                ColTwoBtn.isHidden = true
            case 2:
                ColThreeBtn.isHidden = true
            case 3:
                ColFourBtn.isHidden = true
                
            default:
                return
        }
    }
    
    func toggleBtns(_ state: Bool) {
        ColOneBtn.isHidden = state
        ColTwoBtn.isHidden = state
        ColThreeBtn.isHidden = state
        ColFourBtn.isHidden = state
    }
}

