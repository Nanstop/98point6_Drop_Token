//
//  ViewController.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/20/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import UIKit

class DropTokenViewController: UIViewController {
    var isGameFinished : Bool = false {
        didSet {
            var delay = 0.0
            if isGameFinished == true {
                if let game = DropTokenService.game {
                    delay = 0.1 * Double(game.size)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.GameResultView.isHidden = !self.isGameFinished
            })
        }
    }
    
    var turnCounter : Int = 0 {
        didSet {
            if let isComputerNext = DropTokenService.isComputerNext() {
                if isComputerNext == true {
                    self.moveInitiatedByComputer()
                }
            }
        }
    }
    
    @IBAction func BackBtnPressed(_ sender: UIButton) {
        DropTokenService.game = nil
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var TurnCountLabel: UILabel!
    
    @IBOutlet weak var CurrentTurnTokenImage: UIImageView!
    @IBOutlet weak var GameResultView: UIView!
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var DropTokenCollection: UICollectionView!
    @IBAction func ResetBtnPressed(_ sender: UIButton) {
        DropTokenService.reset()
        gameStart()
    }
    @IBAction func ShareBtnPressed(_ sender: UIButton) {
        GameResultView.isHidden = true
        // Take screenshot
        let screenshot = self.view.screenshot()
        let activityVC = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        GameResultView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameStart()
    }
    
    func setupUIComponents() {
        CurrentTurnTokenImage.backgroundColor = UIColor.red
        CurrentTurnTokenImage.layer.cornerRadius = 50
        
        DropTokenCollection.backgroundColor = UIColor.lightGray
        DropTokenCollection.layer.cornerRadius = 14
        
        GameResultView.layer.cornerRadius = 12
        GameResultView.layer.borderWidth = 1
        GameResultView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func gameStart() {
        isGameFinished = false
        turnCounter = 1
        DispatchQueue.main.async(execute: {
            self.TurnCountLabel.text = String(self.turnCounter)
            self.DropTokenCollection.reloadData()
            if let profileImage = DropTokenService.getPlayerImage() {
                self.CurrentTurnTokenImage.image = profileImage
                self.CurrentTurnTokenImage.backgroundColor = UIColor.clear
            } else {
                self.CurrentTurnTokenImage.image = nil
                self.CurrentTurnTokenImage.backgroundColor = DropTokenService.getPlayerColor()
            }
        })
    }
    
    func makeAMove(_ nextMove: Int) {
        let randomTokenRotationDegree = Int.random(in: -360...360)
        let result = DropTokenService.makeAMove(nextMove, randomTokenRotationDegree)
        var gameResult = ""
        switch result {
        case .Valid:
            animateDrop(nextMove)
        case .Win:
            gameResult = DropTokenService.getWinnerString()
            isGameFinished = true
        case .Draw:
            gameResult = "Draw!"
            isGameFinished = true
        case .Invalid:
            print("Invalid move, please try again")
        }
        if let game = DropTokenService.game {
            let delay = 0.1 * Double(game.size)
            // Update board UI
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.DropTokenCollection.reloadData()
                if self.isGameFinished == false {
                    self.turnCounter += 1
                    self.TurnCountLabel.text = String(self.turnCounter)
                    if let profileImage = DropTokenService.getPlayerImage() {
                        self.CurrentTurnTokenImage.image = profileImage
                        self.CurrentTurnTokenImage.backgroundColor = UIColor.clear
                    } else {
                        self.CurrentTurnTokenImage.image = nil
                        self.CurrentTurnTokenImage.backgroundColor = DropTokenService.getPlayerColor()
                    }
                } else {
                    self.ResultLabel.text = gameResult
                }
            })
        }
    }
    
    // Attempt to make next move
    @objc func moveInitiatedByPlayer(_ sender: UIButton) {
        makeAMove(sender.tag)
    }
    
    func moveInitiatedByComputer() {
        guard let game = DropTokenService.game else { return }
        DropTokenApi.makeAMoveByAI(game.apiMoves) {
            returnedMoves in
            if let moves = returnedMoves {
                if moves.count == game.apiMoves.count + 1 && moves.last != nil {
                    self.makeAMove(moves.last!)
                }
            }
        }
    }
    
    func animateDrop(_ colIndex: Int) {
        guard let game = DropTokenService.game else { return }
        let previousPlayer = game.currentPlayer == 1 ? 2 : 1
        DispatchQueue.main.async(execute: {
            for i in 0 ..< game.size {
                var pendingIndexPath : [IndexPath] = []
                // Clean up previous cell
                if i > 0 {
                    // Remove previous cell color
                    game.board[i - 1][colIndex] = 0
                    let indexPath = IndexPath(row: colIndex, section: i - 1)
                    pendingIndexPath.append(indexPath)
                }
                // Fill current cell
                if game.board[i][colIndex] == 0 {
                    game.board[i][colIndex] = previousPlayer
                    let indexPath = IndexPath(row: colIndex, section: i)
                    pendingIndexPath.append(indexPath)
                } else {
                    return
                }
                if pendingIndexPath.count > 0 {
                    self.DropTokenCollection.reloadItems(at: pendingIndexPath)
                }
            }
        })
    }
    
    func rotationAnimate() -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        basicAnimation.byValue = Double.pi * 2
        basicAnimation.duration = 3
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        basicAnimation.repeatCount = .infinity
        return basicAnimation
    }
}

extension UIView {
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
      }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapOnViewController: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapOnViewController.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnViewController)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat, height: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
