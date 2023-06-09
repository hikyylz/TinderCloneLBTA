//
//  RegisterationViewModel.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 13.05.2023.
//

import UIKit
import FirebaseStorage
import Firebase

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
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
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
            self.saveImageToFirebase(completion: completion)  // completion ları böyle yazabildiğimi bilmiyordum.
        }
    }
    
    
    fileprivate func saveImageToFirebase(completion: @escaping(Error?) -> ()){
        // belirttiğim path ile bir folder oluştuacağım firebaseStorage üzerinde ve app deki tüm image leri orada tutacağım.
        // yeni bir user yaratılırken imageFolder ı da oluşturuluyor.
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.5) ?? Data()
        
        ref.putData(imageData, metadata: nil) { _, err in
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
                self.saveInfoToFirestore(imageURL: URL?.absoluteString, completion: completion)
            }
        }
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String?, completion: @escaping(Error?) -> ()){
        // yeni kullanıcı app e kaydoldu ve firestore da depolayacağım ben bu insanı.
        guard let URL = imageURL else{ return }
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = [
            "fullname" : fullName ?? "",
            "uid" : uid,
            "imageUrl" : URL,
            "minSeekingAge" : 18,
            "maxSeekingAge" : 100
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            if let err = err{
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
}
