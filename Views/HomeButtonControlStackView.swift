//
//  HomeButtonControlStackView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class HomeButtonControlStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: UIImage(imageLiteralResourceName: "refresh_circle"))
    let dismissButton = createButton(image: UIImage(imageLiteralResourceName: "dismiss_circle"))
    let superlikeButton = createButton(image: UIImage(imageLiteralResourceName: "super_like_circle"))
    let likeButton = createButton(image: UIImage(imageLiteralResourceName: "like_circle"))
    let boostButton = createButton(image: UIImage(imageLiteralResourceName: "boost_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // bu class dan oluşturduğum herhangi bir stackView da bu atribute lar otomatikman olacak.
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshButton, dismissButton, superlikeButton , likeButton, boostButton].forEach { button in
            self.addArrangedSubview(button)
        }
        
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
