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
    let name : String
    let age : Int
    let profession : String
    let imageName : String
    
    
    // bir user ı cardViewModel de kullanabilmek adın var bu method.
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string:
        " \(name)", attributes: [.font: UIFont.systemFont (ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string:" \(age)", attributes: [.font: UIFont.systemFont (ofSize: 24, weight: .regular) ]))
        attributedText.append (NSAttributedString(string: "\n  \(profession)", attributes: [.font: UIFont.systemFont (ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageName], attributedString: attributedText, textAlligment: .left)
    }
}
