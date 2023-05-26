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
    var name : String?
    var age : Int?
    var profession : String?
    var imageURL1 : String?
    var imageURL2 : String?
    var imageURL3 : String?
    var bio : String?
    var uid : String?
    
    init(dictionary : [String: Any]){
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageURL1 = dictionary["imageUrl"] as? String
        self.imageURL2 = dictionary["imageUrl2"] as? String
        self.imageURL3 = dictionary["imageUrl3"] as? String
        self.bio = dictionary["bio"] as? String
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
        
        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attributedText, textAlligment: .left)
    }
}
