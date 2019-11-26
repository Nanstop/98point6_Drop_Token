//
//  DropTokenCollectionExtension.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
import UIKit

extension DropTokenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dropTokenBtnCollectionCell", for: indexPath) as! DropTokenCollectionViewBtnCell
            cell.InsertTokenBtn.tag = indexPath.item
            cell.InsertTokenBtn.addTarget(self, action: #selector(moveInitiatedByPlayer), for: .touchUpInside)
            cell.InsertTokenBtn.layer.borderWidth = 1
            if isGameFinished == true {
                cell.InsertTokenBtn.isEnabled = false
                cell.InsertTokenBtn.layer.borderColor = UIColor.lightGray.cgColor
            } else {
                cell.InsertTokenBtn.isEnabled = DropTokenService.isColumnAvailable(indexPath.item)
                cell.InsertTokenBtn.layer.borderColor = UIColor.blue.cgColor
            }
            cell.backgroundColor = UIColor.white
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dropTokenCollectionCell", for: indexPath) as! DropTokenCollectionViewCell
            cell.backgroundColor = UIColor.clear
            if let possibleCustomToken = DropTokenService.decideCellImage(indexPath.section, indexPath.item) {
                cell.tokenImage.image = possibleCustomToken
                cell.tokenImage.clipsToBounds = true
                cell.tokenImage.translatesAutoresizingMaskIntoConstraints = false
                cell.tokenImage.contentMode = .scaleAspectFill
                cell.tokenImage.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
                if let game = DropTokenService.game {
                    let rotationDegree = game.tokenRotation[indexPath.section][indexPath.item]
                    cell.tokenImage.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDegree))
                }
            } else {
                cell.tokenImage.image = nil
                cell.tokenImage.backgroundColor = DropTokenService.decideCellColor(indexPath.section, indexPath.item)
            }
            if isGameFinished == true && DropTokenService.shouldHighlightCell(indexPath.section, indexPath.item) {
                cell.tokenImage.layer.borderColor = UIColor.purple.cgColor
                cell.tokenImage.layer.borderWidth = 2
                let animation = animatePulsatingLayer()
                cell.tokenImage.layer.add(animation, forKey: "rotationAnimation")
            } else {
                cell.tokenImage.layer.borderColor = UIColor.white.cgColor
                cell.tokenImage.layer.borderWidth = 0
            }
            cell.tokenImage.layer.cornerRadius = 30
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 4 {
            return CGSize(width: 90, height: 90)
        }
        return CGSize(width: 90, height: 90)
    }
}
