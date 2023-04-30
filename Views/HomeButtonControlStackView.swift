//
//  HomeButtonControlStackView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class HomeButtonControlStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // bu class dan oluşturduğum herhangi bir stackView da bu atribute lar otomatikman olacak.
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subViews = [ UIImage(imageLiteralResourceName: "refresh_circle"), UIImage(imageLiteralResourceName: "dismiss_circle"), UIImage(imageLiteralResourceName: "super_like_circle"), UIImage(imageLiteralResourceName: "like_circle"), UIImage(imageLiteralResourceName: "boost_circle")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            
            // .withRe.. methodu image ların ekranda düzgün gözkmesine yardımcı oldu.
            button.setImage(image.withRenderingMode(.alwaysOriginal) , for: .normal)
            return button
        }
        
        subViews.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
