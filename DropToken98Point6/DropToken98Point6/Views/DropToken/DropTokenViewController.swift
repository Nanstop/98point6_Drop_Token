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
    @IBOutlet weak var DropTokenCollection: UICollectionView!
    @IBAction func ResetBtnPressed(_ sender: UIButton) {
        initBoard()
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
        toggleBtns(true)
        DispatchQueue.main.async(execute: {
           self.DropTokenCollection.reloadData()
        })
    }
    
    // Call API to get next move
    @objc func makeAMove(_ sender: UIButton) {
        let nextMove = sender.tag
        let result = DropTokenService.makeAMove(nextMove, currentPlayer)
        switch result {
        case .Valid:
            currentPlayer = currentPlayer == 1 ? 2 : 1
        case .Win:
            ResultLabel.text = "Player " + String(currentPlayer) + " WINS!"
            toggleBtns(false)
        case .Draw:
            ResultLabel.text = "Draw!"
            toggleBtns(false)
        default:
            ResultLabel.text = "Invalid move, please try again"
        }
        // Update board UI
        DispatchQueue.main.async(execute: {
            self.DropTokenCollection.reloadData()
        })
    }
    
    func toggleBtns(_ state: Bool) {
        for i in 0...4 {
            let indexPath = IndexPath(row: i, section: 4)
            if let cell = DropTokenCollection.cellForItem(at: indexPath) as? DropTokenCollectionViewBtnCell {
                cell.InsertTokenBtn.isEnabled = state
            }
        }
        DispatchQueue.main.async(execute: {
           self.DropTokenCollection.reloadData()
        })
    }
}

