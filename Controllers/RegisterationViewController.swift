//
//  RegisterationViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 8.05.2023.
//

import UIKit

class RegisterationViewController: UIViewController {
    
    // UIcomponents
    let selectPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("tap to select photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    let fullNameTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter full name"
        TF.backgroundColor = .white
        return TF
    }()
    let paswordTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter pasword"
        TF.isSecureTextEntry = true       // yazının gizli yazılmasını sağlayacak bir özellik bu.
        TF.backgroundColor = .white
        return TF
    }()
    let emailTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter email"
        TF.keyboardType = .emailAddress   // klavyede @ sembolünü görmeye yarayacak bu satır.
        TF.backgroundColor = .white
        return TF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGradientColor()
        setUpStackViewLayout()
        
    }
    
    fileprivate func setUpStackViewLayout(){
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            paswordTextField
        ])
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setUpGradientColor(){
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPink.cgColor]
        gradiantLayer.locations = [0, 1]
        view.layer.addSublayer(gradiantLayer)
        gradiantLayer.frame = view.bounds
        
    }

}
