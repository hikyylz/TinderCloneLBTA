//
//  CardViewModel.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 4.05.2023.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}


// view model is supposed to represend the state of view.
class CardViewModel{
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlligment: NSTextAlignment      // yazımın ekranda nerede duracağını belirten şeye alignment denir.
    fileprivate var imageIndex = 0 {
        didSet{
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image ?? UIImage())   // burada declare ediyorum closure u.
        }
    }
    
    /// reactive programing örneğiymiş bu değişken.
    // bu closure yapısını burada init edileceğini söylüyorum.
    // init edilmesi view class larından birinde olacak çünkü, view ile etkileşime girmek View class ının logic kontrol ve işlemler operasyonlar ViewModel class larının işidir.
    var imageIndexObserver : ((Int, UIImage) -> ())?
    
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlligment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlligment = textAlligment
    }
    
    func advanceToNextPhoto(){
        imageIndex = min(imageIndex+1, imageNames.count-1)
    }
    
    func goTopreviousPhoto(){
        imageIndex = max(imageIndex-1, 0)
    }
    
}
