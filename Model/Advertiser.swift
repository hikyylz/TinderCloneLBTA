//
//  Advertiser.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 4.05.2023.
//

import Foundation
import UIKit

struct Advertiser : ProducesCardViewModel{
    let title: String
    let bradnName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel{
        
        /// NSAttributedString şöyle ayarlanır; yazmasını istediğin şeyi ve o string in ozelliklerini de bir dic<> yapısı içerisinde verirsin. ve voila :)
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append( NSAttributedString(string: "\n" + bradnName, attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAlligment: .center)
    }
}
