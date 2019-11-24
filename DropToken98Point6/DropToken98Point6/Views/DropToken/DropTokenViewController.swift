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
    var isGameFinished : Bool = false
    var imagePicker : UIImagePickerController!
    var selectedProfileToken : Int? = nil
    @IBOutlet weak var PlayerOneTextField: UITextField!
    @IBOutlet weak var PlayerOneTokenBtn: UIButton!
    @IBAction func PlayerTokenBtnPressed(_ sender: UIButton) {
        selectedProfileToken = 1
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var PlayerTwoView: UIView!
    @IBOutlet weak var PlayerTwoTextField: UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        setupUIComponents()
        // Do any additional setup after loading the view.
        DropTokenCollection.backgroundColor = UIColor.lightGray
    }
    
    func setupUIComponents() {
        PlayerOneTokenBtn.backgroundColor = UIColor.red
        PlayerOneTokenBtn.layer.cornerRadius = 25
        
        PlayerTwoTokenBtn.backgroundColor = UIColor.blue
        PlayerTwoTokenBtn.layer.cornerRadius = 25
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func initBoard() {
        DropTokenService.initBoard()
        currentPlayer = 1
        isGameFinished = false
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
            isGameFinished = true
        case .Draw:
            ResultLabel.text = "Draw!"
            isGameFinished = true
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

