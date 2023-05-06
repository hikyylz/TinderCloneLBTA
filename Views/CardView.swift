//
//  CardView.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 2.05.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let infoLabel = UILabel()
    fileprivate let cardImage = UIImageView(image: UIImage(named: "lady1"))
    fileprivate let threshold : CGFloat = 100
    fileprivate let gradientLayer = CAGradientLayer()
    
    // bu değişken..
    var cardViewModel : CardViewModel!{
        didSet{
            let imageName = cardViewModel.imageNames.first ?? ""
            cardImage.image = UIImage(named: imageName)
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlligment
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        let pangester = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pangester)
        
    }
    
    fileprivate func setUpLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        cardImage.contentMode = .scaleAspectFill
        addSubview(cardImage)
        cardImage.fillSuperview()
        
        setUpGradientLayout()
        
        addSubview(infoLabel)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        
        // view umda göstereceğim yazıların özelliklerini buradan ayarlıyorum.
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate func setUpGradientLayout(){
        // how we can draw a gradient with swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        // frame i override edilmiş olan
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        // ekrandaki her alt görsel kendini oluştururken çağırılab nir mtehodmuş bu.
        gradientLayer.frame = self.frame
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseOut) {
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
            self.removeFromSuperview()   // insanları swap yaptıkdan sonra diğer kişiye geçebilmem için ortadan kaybolması lazım.
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
