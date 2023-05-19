//
//  User.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 3.05.2023.
//

/// viewmodel  folder ındaki yapılar ekranda göstereceğim şeyleri en ince ayrıntısına kadar ayarladığım ve controller a verdiğim şeyleri yazdığım yer.

import Foundation
import UIKit

struct User : ProducesCardViewModel{
    // app i kulanacak kullanıcılar için structre burada 
    let name : String?
    let age : Int?
    let profession : String?
    let imageURL : String?
    let uid : String?
    
    init(dictionary : [String: Any]){
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageURL = dictionary["imageURL"] as? String
        self.uid = dictionary["uid"] as? String
    }
    
    
    // bir user ı cardViewModel de kullanabilmek adın var bu method.
    func toCardViewModel() -> CardViewModel{
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? profession! : "not available"
        
        let attributedText = NSMutableAttributedString(string:
        " \(name ?? "")", attributes: [.font: UIFont.systemFont (ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string:" \(ageString)", attributes: [.font: UIFont.systemFont (ofSize: 24, weight: .regular) ]))
        attributedText.append (NSAttributedString(string: "\n  \(professionString)", attributes: [.font: UIFont.systemFont (ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageURL ?? ""], attributedString: attributedText, textAlligment: .left)
    }
}
