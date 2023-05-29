//
//  AgeRangeTableViewCell.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 27.05.2023.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    // bu iki component ekranda kaydırılarak bir değeri ayarlamama yarıyorlarmış.
    let minSlider = UISlider()
    let maxSlider = UISlider()
    
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
        /*
        // bu override nasıl çalışıyor anlamadım ve override edilebilecek şeylerin çokluğu korkutuyor :0
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
         */
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(minLabel)
        self.contentView.addSubview(minSlider)
        self.contentView.addSubview(maxLabel)
        self.contentView.addSubview(maxSlider)
        
        
        // Slider'ları hücre içinde yerleştirme
        minSlider.translatesAutoresizingMaskIntoConstraints = false
        maxSlider.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            minSlider.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            minSlider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            minSlider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            minLabel.topAnchor.constraint(equalTo: minSlider.bottomAnchor, constant: 8),
            minLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            minLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            maxSlider.topAnchor.constraint(equalTo: minLabel.bottomAnchor, constant: 8),
            maxSlider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            maxSlider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            maxLabel.topAnchor.constraint(equalTo: maxSlider.bottomAnchor, constant: 8),
            maxLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            maxLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            maxLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])// label ları yukarı gelecek şekilde ayarla ve her şey hazır..
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
