//
//  CustomTextField.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 8.05.2023.
//

import UIKit


// text Label
class CustomTextLabel: UILabel {
    
    var padding : CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: padding, dy: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




// bu custom text field class ından ürettiğim her text field height ı 50 olacak.
class CustomTextField : UITextField{
    
    let padding : CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // alttaki iki method textField ların içiyle oynamamı sağlıyor.
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // text field daki yazının yazıldığı alanı veriyormuş sana.
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // editlediğin textRect i bu methodla gösterebiliyormuşsun.
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 50)
    }
}
