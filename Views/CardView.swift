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
    fileprivate let threshold : CGFloat = 150
    fileprivate var imageIndex = 0
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barsStackView = UIStackView()
    
    // bu değişken..
    var cardViewModel : CardViewModel!{
        didSet{
            let imageName = cardViewModel.imageNames.first ?? ""
            cardImage.image = UIImage(named: imageName)
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlligment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = UIColor.gray
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setUpImageIndexObserver()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setUpImageIndexObserver(){
        // imageIndexObserver işte burada initalize edilecek çünkü view larla etkileşime gireceksem bu class ın içerinde olmalıdır.
        cardViewModel.imageIndexObserver = { (imageIndx, image) in
            self.barsStackView.arrangedSubviews.forEach { view in
                view.backgroundColor = .gray
            }
            self.cardImage.image = image
            self.barsStackView.arrangedSubviews[imageIndx].backgroundColor = .white
        }
    }
    
    fileprivate func setUpLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        cardImage.contentMode = .scaleAspectFill
        addSubview(cardImage)
        cardImage.fillSuperview()
        
        setUpBarsStackView()
        setUpGradientLayout()
        
        addSubview(infoLabel)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        
        // view umda göstereceğim yazıların özelliklerini buradan ayarlıyorum.
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate func setUpBarsStackView(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 3))
        
        // vu StrackView içerisine ekleyeceğim subView ların aralarındaki boşluğu bununla ayarlamam gerekmekte.
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
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
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        let location = gesture.location(in: nil)
        let nextPhoto = location.x > frame.width/2 ? true : false
        if nextPhoto{
            cardViewModel.advanceToNextPhoto()
        }else{
            cardViewModel.goTopreviousPhoto()
        }
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
        let photoLiked = gesture.translation(in: nil).x > threshold  // eğer swap yeterince istekliyse true atanır.
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
            //self.transform = .identity
            //self.removeFromSuperview()   // insanları swap yaptıkdan sonra diğer kişiye geçebilmem için ortadan kaybolması lazım.
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
