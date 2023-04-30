//
//  TopNavigationStackView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        axis = .horizontal
        
        let subviews = [UIImage(imageLiteralResourceName: "top_left_profile"), UIImage(imageLiteralResourceName: "app_icon"), UIImage(imageLiteralResourceName: "top_right_messages")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(.alwaysOriginal) , for: .normal)
            return button
        }
        
        subviews.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
