//
//  ViewController.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/20/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var apiMoves : [Int] = []
    var board : [[Int]] = []
    var diagnalMap : [Int] = [3,2,1,0]
    var currentPlayer : Int = 0
    
    @IBOutlet weak var ResultLabel: UILabel!
    @IBAction func ResetBtnPressed(_ sender: UIButton) {
        initBoard()
        apiMoves = []
        ResultLabel.isHidden = true
        ResultLabel.text = ""
        ColOneBtn.isHidden = false
        ColTwoBtn.isHidden = false
        ColThreeBtn.isHidden = false
        ColFourBtn.isHidden = false
        
    }
    
    func initBoard() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        for i in 0...3 {
            for j in 0...3 {
                board[i][j] = 0
            }
        }
        currentPlayer = 1
        ResultLabel.text = "Player 1's turn"
        DispatchQueue.main.async(execute: {
           self.DropTokenCollection.reloadData()
        })

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
    
    // Call API to get next move
    func makeAMove(_ nextMove: Int) {
        var moveMade = false
        for i in (0...3).reversed() {
            if moveMade == true {
                currentPlayer = currentPlayer == 1 ? 2 : 1
                ResultLabel.text = "Player " + String(currentPlayer) + "'s turn"
                return
            }
            if board[i][nextMove] == 0 {
                board[i][nextMove] = currentPlayer
                DispatchQueue.main.async(execute: {
                    self.DropTokenCollection.reloadData()
                })
                moveMade = true
                if validateWin(i, nextMove) {
                    ResultLabel.text = "Player " + String(currentPlayer) + " WINS!"
                    ResultLabel.isHidden = false
                    lockGame()
                    return
                } else {
                    if i == 0 {
                        disableCurrentColumn(nextMove)
                    }
                }
            }
        }
        if moveMade == false {
            ResultLabel.text = "Draw!"
            ResultLabel.isHidden = false
            lockGame()
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
    
    func lockGame() {
        ColOneBtn.isHidden = true
        ColTwoBtn.isHidden = true
        ColThreeBtn.isHidden = true
        ColFourBtn.isHidden = true
    }
    
    // Validate winner
    func validateWin(_ x: Int, _ y: Int) -> Bool{
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
    
    func decideColor(_ cellValue: Int) -> UIColor {
        switch cellValue {
        case 1:
            return UIColor.red
        case 2:
            return UIColor.blue
        default:
            return UIColor.white
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dropTokenCollectionCell", for: indexPath) as! DropTokenCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.tokenImage.backgroundColor = decideColor(board[indexPath.section][indexPath.item])
        cell.tokenImage.layer.cornerRadius = 30
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

