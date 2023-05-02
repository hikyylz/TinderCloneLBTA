//
//  CardView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 2.05.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let cardImage = UIImageView(image: UIImage(named: "lady"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(cardImage)
        cardImage.fillSuperview()
        
        let pangester = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pangester)
        
        
        
    }
    
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        // ekranda dokunduğum noktaların (x, y) kordinatlarını alabiliyorum.
        //print(gesture.translation(in: nil))
        
        // translation değişkeniyle ekranda dokunduğum konumun yerini x, y olarak tutabiliyorum.
        // self.transform ile de gester ı eklediğim view un konumunu değiştirebiliyorum
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        switch gesture.state{
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded()
        default:
            break
        }
        
    }
    
    // gester ın kendisini nasıl para olarak oldığını anlayamadım.
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(){
        // bu animate.. methoduyla bazı bouncing özelliklerini ayarlayabiliyorsun.
        UIView.animate(withDuration: 0.70, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
            // ended olduğunda belirtilen timing özellikleriyle bu action gerçekleşecek.
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
