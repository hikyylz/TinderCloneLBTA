//
//  RegisterationViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 8.05.2023.
//

import UIKit

class RegisterationViewController: UIViewController {
    fileprivate let gradiantLayer = CAGradientLayer()
    
    // lazy ön ekiyle tanımlanmış olan buı variable, kodumda ona ihtiyacım olduğunda kimlik kazanacak. onu kullanmadığım sürece nil olarak duran bir şey sadece. Koduma hız katan bir özellik bu.
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        horizontalView
    ])
    
    lazy var horizontalView : UIStackView = {
        let hv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            paswordTextField,
            registerButton
        ])
        hv.axis = .vertical
        hv.spacing = 8
        hv.distribution = .fillEqually
        return hv
    }()
    
    
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
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 25
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
        setUpOverallStackView()
        setUpNotificationObserver()
        setUpTapGestureForDismissingKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bu VC dan çıkarken eğer notification center daki observer ları silmezsem retain cycle oluyormuş ??
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    fileprivate func setUpTapGestureForDismissingKeyboard(){
        let gester = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gester)
    }
    
    @objc fileprivate func dismissKeyboard(){
        self.view.endEditing(true)  // dismisses keyboard
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
            self.view.transform = .identity
        }
    }
    
    fileprivate func setUpNotificationObserver(){
        // ekranda keyboard gözükmeden önce UIResponder bir notification duyururmuş.
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyshowup), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyshowup(notification: Notification){
        // keyboard açıldığında view umun yukarı kayarak iyi UX deneyeimi sağlamaya çalışıyorum..
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{ return }
        let keyboardFrame = value.cgRectValue
        let bottonSpacing = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottonSpacing
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // ıos interface enviroment change ini anlayabilen bir yapıymış bu.
        super.traitCollectionDidChange(previousTraitCollection)
        
        // landScape pozisyonunda ekranda farklı şeyler gözüksün istiyorsam bu blak devreye girecek.
        if self.traitCollection.verticalSizeClass == .compact{
            overallStackView.axis = .horizontal
        }else{
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setUpOverallStackView(){
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 274).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    override func viewWillLayoutSubviews() {
        // bu method..
        // ekrandaki view lar landScape pozısyonuna geldiğinde yeniden 'layout' edilirlemiş, bu ayarlamayı tekrardan yaparken bazı değişiklikler yapmamız gerekmekte.
        super.viewWillLayoutSubviews()
        gradiantLayer.frame = view.bounds
    }
    
    fileprivate func setUpGradientColor(){
        gradiantLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPink.cgColor]
        gradiantLayer.locations = [0, 1.1]
        view.layer.addSublayer(gradiantLayer)
        gradiantLayer.frame = view.bounds
        
    }

}
