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

struct CardViewModel{
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlligment: NSTextAlignment      // yazımın ekranda nerede duracağını belirten şeye alignment denir.
}
