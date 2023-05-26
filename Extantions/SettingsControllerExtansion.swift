//
//  SettingsControllerExtansion.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 25.05.2023.
//

import UIKit
import JGProgressHUD
import FirebaseStorage

extension SettingsController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            if let picker = picker as? CustomImagePickerController{
                picker.imageButton?.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                
                let StorageHUD = JGProgressHUD(style: .dark)
                StorageHUD.textLabel.text = "image saving.."
                StorageHUD.show(in: self.view)
                
                let filename = UUID().uuidString
                let ref = Storage.storage().reference(withPath: "/images/\(filename)")
                guard let uploadData = selectedImage.jpegData(compressionQuality: 0.5) else{return}
                ref.putData(uploadData) { _, err in
                    if let _ = err{
                        print("image not saving")
                        return
                    }
                    StorageHUD.dismiss()
                    // saving done
                    ref.downloadURL { url, err in
                        if let _ = err{
                            return
                        }
                        // url fetching done.
                        if picker.imageButton == self.image1Button{
                            self.currentUser?.imageURL1 = url?.absoluteString
                        }else if picker.imageButton == self.image2Button{
                            self.currentUser?.imageURL2 = url?.absoluteString
                        }else{
                            self.currentUser?.imageURL3 = url?.absoluteString
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}
