//
//  DropTokenImagePickerExtension.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
import UIKit

extension DropTokenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let imageData = pickedImage.pngData()
            DispatchQueue.main.async {
//                if self.selectedProfileToken == 1 {
//                    self.PlayerOneTokenBtn.setImage(pickedImage, for: .normal)
//                    self.PlayerOneTokenBtn.layer.cornerRadius = 25
//                    UserDefaults.standard.set(imageData, forKey: "playerOneProfile")
//                } else {
//                    self.PlayerTwoTokenBtn.setImage(pickedImage, for: .normal)
//                    self.PlayerTwoTokenBtn.layer.cornerRadius = 25
//                    UserDefaults.standard.set(imageData, forKey: "playerTwoProfile")
//                }
            }
        }
        self.dismiss(animated: true)
    }
}
