//
//  DropTokenImagePickerExtension.swift
//  DropToken98Point6
//
//  Created by Nan Shan on 11/23/19.
//  Copyright © 2019 Nan Shan. All rights reserved.
//

import Foundation
import UIKit

extension DropTokenConfigViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            DispatchQueue.main.async {
                if self.selectedCustomToken == 1 {
                    self.PlayerOneCustomTokenBtn.setImage(pickedImage, for: .normal)
                } else {
                    self.PlayerTwoCustomTokenBtn.setImage(pickedImage, for: .normal)
                }
            }
        }
        self.dismiss(animated: true)
    }
}
