//
//  AgeRangeTableViewCell.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 27.05.2023.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    // bu iki component ekranda kaydırılarak bir değeri ayarlamama yarıyorlarmış.
    let minSlader : UISlider = {
        let Slider = UISlider()
        Slider.minimumValue = 18
        Slider.maximumValue = 18
        return Slider
    }()
    
    let maxSlader : UISlider = {
        let Slider = UISlider()
        Slider.minimumValue = 18
        Slider.maximumValue = 18
        return Slider
    }()
    
    let minLabel : UILabel = {
       let label = AgeRangeLabel()
        label.textAlignment = .center
        label.text = "min 50"
        return label
    }()

    let maxLabel : UILabel = {
       let label = AgeRangeLabel()
        label.textAlignment = .center
        label.text = "max 90"
        return label
    }()
    
    class AgeRangeLabel : UILabel{
        // bu override nasıl çalışıyor anlamadım ve override edilebilecek şeylerin çokluğu korkutuyor :0
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minSlader.isUserInteractionEnabled = true
        maxSlader.isUserInteractionEnabled = true   // bunlar hareket etmiyor.
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlader]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlader])
        ])
        
        overallStackView.axis = .vertical // dikey
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
