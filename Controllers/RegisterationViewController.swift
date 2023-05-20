//
//  RegisterationViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 8.05.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import JGProgressHUD

// extansion şeklinde yazmak bu şeyleri okunurluğu arttırıyor.
extension RegisterationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            registrationVM.bindableImage.value = image
        }
        self.selectPhotoButton.setTitle(nil, for: .normal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegisterationViewController: UIViewController {
    fileprivate let gradiantLayer = CAGradientLayer()
    fileprivate let registrationVM = RegisterationViewModel()
    fileprivate var registeringHUD = JGProgressHUD(style: .dark)
    
    // lazy ön ekiyle tanımlanmış olan bu variable, kodumda ona ihtiyacım olduğunda kimlik kazanacak. onu kullanmadığım sürece nil olarak duran bir şey sadece. Koduma hız katan bir özellik bu.
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
        button.heightAnchor.constraint(equalToConstant: 345).isActive = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill  // photo sadece çerçeveye sığsın esnemeden.
        button.imageView?.fillSuperview()
        button.clipsToBounds = true  // subView ların bunun çerçevesine tam oturmasını sağlayan bir değişkenmiş bu !
        return button
    }()
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    let fullNameTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter full name"
        TF.backgroundColor = .white
        TF.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return TF
    }()
    let paswordTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter pasword"
        TF.isSecureTextEntry = true       // yazının gizli yazılmasını sağlayacak bir özellik bu.
        /// similatör de hardware keyboard ile bu güvenlik özelliği sıkıntı yaşıyorlar !
        TF.backgroundColor = .white
        TF.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return TF
    }()
    let emailTextField : CustomTextField = {
        let TF = CustomTextField(padding: 16)
        TF.placeholder = "Enter email"
        TF.keyboardType = .emailAddress   // klavyede @ sembolünü görmeye yarayacak bu satır.
        TF.backgroundColor = .white
        TF.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return TF
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpGradientColor()
        setUpOverallStackView()
        setUpNotificationObserver()
        setUpTapGestureForDismissingKeyboard()
        setupRegisterationViewModelObserver()
    }
    
    @objc fileprivate func handleSelectPhoto(){
        let imagePC = UIImagePickerController()
        imagePC.modalPresentationStyle = .fullScreen   // chatgpt e kurban olayım :)
        imagePC.delegate = self
        imagePC.allowsEditing = true
        present(imagePC, animated: true)
    }
    
    @objc fileprivate func handleRegister(){
        self.dismissKeyboard()
        registrationVM.performRegister { [weak self] err in
            if let err = err{
                self?.showHUDwithErr(err)
                return
            }
            // registering done.
            let destVC = HomeController()
            destVC.modalPresentationStyle = .fullScreen
            self!.present(destVC, animated: true)
            
        }
    }
    
    fileprivate func showHUDwithErr(_ err: Error){
        registeringHUD.dismiss()
        // üç sn ekranımda gözükecek bir progress kutucuğu..
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registering"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2)
    }
    
    @objc fileprivate func handleTextChange(TF: CustomTextField){
        if TF == fullNameTextField{
            registrationVM.fullName = TF.text
        }else if TF == emailTextField{
            registrationVM.email = TF.text
        }else if TF == paswordTextField{
            registrationVM.password = TF.text
        }
    }
    
    
    fileprivate func setupRegisterationViewModelObserver(){
        // Bindable yapısını kullandım alttaki iki closure da.
        
        // .bind diyerek tanımlaman gereken closure a isim vermeden o closure u tanımlamış oluyorsun.
        // değer bindable class ındaki value a atanıyor, o da kendi closure atamasına bağlı ancak closure tanımı burda senin elinde.
        registrationVM.bindableIsFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? .black : .lightGray
            self.registerButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        
        registrationVM.bindableImage.bind { [unowned self] img in self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationVM.bindableIsRegistering.bind { [unowned self] isRegistering in
            if isRegistering == true{
                registeringHUD.textLabel.text = "Register"
                registeringHUD.show(in: self.view)
            }else{
                self.registeringHUD.dismiss()
            }
        }
        
        
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
        // ios interface enviroment change ini anlayabilen bir yapıymış bu.
        super.traitCollectionDidChange(previousTraitCollection)
        
        // landScape pozisyonunda ekranda farklı şeyler gözüksün istiyorsam bu blok devreye girecek.
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
