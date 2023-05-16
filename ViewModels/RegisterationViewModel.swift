//
//  RegisterationViewModel.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 13.05.2023.
//

import UIKit

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
    
    var bindableImage = Bindable<UIImage>()
    
    var bindableIsFormValid = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
}
