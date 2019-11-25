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
            PlayerOneTokenBtn.layer.borderWidth = currentPlayer == 1 ? 3 : 0
            PlayerOneTokenBtn.layer.borderColor = UIColor.gray.cgColor
            PlayerTwoTokenBtn.layer.borderWidth = currentPlayer == 1 ? 0 : 3
            PlayerTwoTokenBtn.layer.borderColor = UIColor.gray.cgColor
        }
    }
    var isGameFinished : Bool = false {
        didSet {
            var delay = 0.0
            if isGameFinished == true {
                delay = 0.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.GameResultView.isHidden = !self.isGameFinished
            })
        }
    }
    var imagePicker : UIImagePickerController!
    var selectedProfileToken : Int? = nil
    
    @IBOutlet weak var GameResultView: UIView!
    @IBOutlet weak var PlayerOneTokenBtn: UIButton!
    @IBAction func PlayerTokenBtnPressed(_ sender: UIButton) {
        selectedProfileToken = 1
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var PlayerTwoView: UIView!
    @IBOutlet weak var PlayerTwoTokenBtn: UIButton!
    @IBAction func PlayerTwoTokenBtnPressed(_ sender: UIButton) {
        selectedProfileToken = 2
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var DropTokenCollection: UICollectionView!
    @IBAction func ResetBtnPressed(_ sender: UIButton) {
        initBoard()
    }
    @IBAction func ShareBtnPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        setupUIComponents()
    }
    
    func setupUIComponents() {
        PlayerOneTokenBtn.backgroundColor = UIColor.red
        PlayerOneTokenBtn.layer.cornerRadius = 50
        
        PlayerTwoTokenBtn.backgroundColor = UIColor.blue
        PlayerTwoTokenBtn.layer.cornerRadius = 50
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        DropTokenCollection.backgroundColor = UIColor.lightGray
        DropTokenCollection.layer.cornerRadius = 14
        
        GameResultView.layer.cornerRadius = 12
        GameResultView.layer.borderWidth = 1
        GameResultView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func initBoard() {
        DropTokenService.initBoard()
        currentPlayer = 1
        isGameFinished = false
        DispatchQueue.main.async(execute: {
           self.DropTokenCollection.reloadData()
        })
    }
    
    // Attempt to make next move
    @objc func makeAMove(_ sender: UIButton) {
        let nextMove = sender.tag
        let randomTokenRotationDegree = Int.random(in: -360...360)
        let result = DropTokenService.makeAMove(nextMove, currentPlayer, randomTokenRotationDegree)
        switch result {
        case .Valid:
            animateDrop(nextMove)
            currentPlayer = currentPlayer == 1 ? 2 : 1
        case .Win:
            ResultLabel.text = "Player " + String(currentPlayer) + " WINS!"
            isGameFinished = true
        case .Draw:
            ResultLabel.text = "Draw!"
            isGameFinished = true
        case .Invalid:
            print("Invalid move, please try again")
        }
        // Update board UI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.DropTokenCollection.reloadData()
        })
    }
    
    func animateDrop(_ colIndex: Int) {
        for i in 0...3 {
            var pendingIndexPath : [IndexPath] = []
            // Clean up previous cell
            if i > 0 {
                // Remove previous cell color
                DropTokenService.board[i-1][colIndex] = 0
                let indexPath = IndexPath(row: colIndex, section: i - 1)
                pendingIndexPath.append(indexPath)
            }
            // Fill current cell
            if DropTokenService.board[i][colIndex] == 0 {
                DropTokenService.board[i][colIndex] = currentPlayer
                let indexPath = IndexPath(row: colIndex, section: i)
                pendingIndexPath.append(indexPath)
            } else {
                return
            }
            if pendingIndexPath.count > 0 {
                DropTokenCollection.reloadItems(at: pendingIndexPath)
            }
        }
    }
    
    func animatePulsatingLayer() -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        basicAnimation.byValue = Double.pi * 2
        basicAnimation.duration = 3
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        basicAnimation.repeatCount = .infinity
        return basicAnimation
    }
}

