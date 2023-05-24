//
//  SettingsTableViewCell.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 23.05.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    var textField : CustomTextField = {
        let tf = CustomTextField(padding: 24)
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true   // textfield ıma yazmamı sağlıyor.
        addSubview(textField)
        textField.fillSuperview()  // section ın boyutunu ayarlamıştım ona uysun diye bunu yazıyorum.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
