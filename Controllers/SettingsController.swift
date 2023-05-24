//
//  SettingsController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/19/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

extension SettingsController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                
            }
        }
        dismiss(animated: true)
    }
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController {
    
    // instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var header: UIView = {
        let header = UIView()
        fillUpHeaderWithImageButtons(header)
        return header
    }()
    
    var currentUser: User?
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.imageView?.fillSuperview()
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        // tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive   // scroll işlemi başlayınca keyboard u ekrandan kaldır.
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser(){
        // current user ın settings bilgilerini almam gerek..
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapShot, err in
            if let err = err{
                print(err)
                return
            }
            
            guard let userData = snapShot?.data() as? [String : Any] else {return}
            self.currentUser = User(dictionary: userData)
            self.loadCurrentUserPhotoToImageButtons()
            self.tableView.reloadData()   // table ın yeniden yüklenmesi gerekli.
        }
    }
    
    fileprivate func loadCurrentUserPhotoToImageButtons(){
        guard let imageUrl = currentUser?.imageURL, let url = URL(string: imageUrl) else { return }
        // why exactly do we use this SDWebImageManager class to load our images?
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            // her nedense title image gelince kaybolmuyor ve imageView button içerisinde tam olarak oturmuyormuş.
            self.image1Button.setTitle(nil, for: .normal)
        }
    }
    
    fileprivate func fillUpHeaderWithImageButtons(_ header: UIView) {
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // ilh header her halükarda scroll edildikçe kaybolmuyor ekrandan .
        // header: tableviewcell in tanımlayaıcı ismidir .
        if section == 0 {
            return header
        }
        else{
            let headerLabel = CustomTextLabel(padding: 16)
            switch section {
            case 1:
                headerLabel.text = "Name"
            case 2:
                headerLabel.text = "Profession"
            case 3:
                headerLabel.text = "Age"
            default:
                headerLabel.text = "Bio"
            }
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // her bir section da bir header bir cell bir footer vardır , bu ek iki baş ve kuyruk kısımlarına da veri koyabiliyorum.
        // ilk header ve son footer her daim ekranda gözükürler.
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = currentUser?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = currentUser?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = currentUser?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.currentUser?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.currentUser?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.currentUser?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave(){
        guard let currUserUid = Auth.auth().currentUser?.uid else {return}
        
        let documentData = [
            "uid" : currUserUid,
            "fullname" : currentUser?.name ?? "",
            "imageUrl" : currentUser?.imageURL ?? "",
            "age" : currentUser?.age ?? 0,
            "profession" : currentUser?.profession ?? ""
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(currUserUid).setData(documentData) { err in
            if let _ = err{
                print("not saving")
            }
            // saving done
        }
    }

}