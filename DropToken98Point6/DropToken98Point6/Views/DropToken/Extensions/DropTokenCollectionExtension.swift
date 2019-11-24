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
            cell.InsertTokenBtn.addTarget(self, action: #selector(makeAMove), for: .touchUpInside)
            cell.InsertTokenBtn.isEnabled = DropTokenService.isColumnAvailable(indexPath.item)
            cell.backgroundColor = UIColor.white
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dropTokenCollectionCell", for: indexPath) as! DropTokenCollectionViewCell
            cell.backgroundColor = UIColor.clear
            cell.tokenImage.backgroundColor = DropTokenService.decideCellColor(indexPath.section, indexPath.item)
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
