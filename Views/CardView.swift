//
//  CardView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 2.05.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let cardImage = UIImageView(image: UIImage(named: "lady"))
    fileprivate let threshold : CGFloat = 100

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
        
        switch gesture.state{
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            break
        }
        
    }
    
    // gester ın kendisini nasıl para olarak oldığını anlayamadım.
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        let degree : CGFloat = translation.x / 25
        let angle = degree * .pi / 180
        
        // CGAffineTransform class ı 2D hareketler yapmama olanak tanıyan bir class mış.
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)  // transladedby kısmı ile dönen view umu bir de yatayda hareket ettirebildim.
        
        //let translation = gesture.translation(in: nil)
        //self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer){
        let photoLiked = gesture.translation(in: nil).x > threshold  // eğer swap yeterince istekliyse trueatanır.
        let photoDoesntLiked = gesture.translation(in: nil).x < (-1 * threshold)
        
        // bu animate.. methoduyla bazı bouncing özelliklerini ayarlayabiliyorsun.
        UIView.animate(withDuration: 0.70, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            // ended olduğunda belirtilen timing özellikleriyle bu action gerçekleşecek.
            
            if photoLiked{
                
                // like swap
                let offScreenTransform = self.transform.translatedBy(x: 500, y: 0)
                self.transform = offScreenTransform
                
            }else if photoDoesntLiked{
                
                // does not like swap
                let offScreenTransform = self.transform.translatedBy(x: -500, y: 0)
                self.transform = offScreenTransform
                
            }
            else{
                self.transform = .identity
            }
            
            
        } completion: { _ in
            // bu blok swap işleminden sonra olacakları içerecektir.
            self.transform = .identity
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
