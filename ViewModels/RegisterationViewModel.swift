//
//  RegisterationViewModel.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 13.05.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegisterationViewModel{
    
    /// bu üç değişken de hangi sırayla olursa olsun doldurulursa ekrandan, reactive closure um çalışacak ve istediğim View özelliği View class larından birinde gerçekleşecek. Logic operasyonu burada oluyor sadece.
    var fullName : String? {
        didSet{
            checkFormValidity()
        }
    }
    var password : String? {
        didSet{
            checkFormValidity()
        }
    }
    var email : String? {
        didSet{
            checkFormValidity()
        }
    }
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegister(completion: @escaping(Error?) -> ()){
        // logic operasyonlarının sonucu ekranda gösterilecek olan view u etkiliyor. bu işlemlerin ViewModel class ında olması gerekmekte.
        self.bindableIsRegistering.value = true
        guard let email = email, let password = password else{ return }
        Auth.auth().createUser(withEmail: email, password: password) { AuthResponse, error in
            if let err = error{
                // user oluşturulamadı.
                completion(err)
                return
            }
            // user oluştu
            // belirttiğim path ile bir folder oluştuacağım firebaseStorage üzerinde ve app deki tüm image leri orada tutacağım.
            // yeni bir user yaratılırken imageFolder ı da oluşturuluyor.
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.5) ?? Data()
            
            ref.putData(imageData) { _, err in
                if let err = err {
                    // user ın image ı kaydedilemedi..
                    completion(err)
                    return
                }
                // imageFolder a photo yüklendi
                ref.downloadURL { URL, err in
                    if let err = err{
                        // yüklenen image in URL sini indiremedim..
                        completion(err)
                        return
                    }
                    self.bindableIsRegistering.value = false  // registering işlemi bittikten sonsa hud i dissmis eden kodu çalıştırmak için bunu atamam lazım.
                    // URL yi firestore a kaydetmek için fetch ledim burada..
                    
                }
            }
        }
    }
    
}
