//
//  UserDetailsViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 3.06.2023.
//

import UIKit
import SDWebImage

class UserDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var userCardViewModel : CardViewModel!{
        didSet{
            // bu değişkene atama işlemleri gerçekleştikten sonra şu işlemleri yap...
            // ekranda gözüken card view ile hangi kullanıcının bilgilerini görmek istiyorsam çalışan bir yapı var burada.
            infoLabel.attributedText = userCardViewModel.attributedString
            guard let firstImageUrlString = userCardViewModel.imageUrls.first, let myUrl = URL(string: firstImageUrlString) else{return}
            personImageView.sd_setImage(with: myUrl)
        }
    }
    
    lazy var scroolView : UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never  // ekranın üzerinde boşluk yaratma!
        sv.delegate = self
        return sv
    }()
    var personImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kelly1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    var infoLabel : UILabel = {
        let il = UILabel()
        il.text = "user name\nkaan\nuser age\n23"
        il.numberOfLines = 0   // bu atribute biraz sıkıntılıymış.
        return il
    }()
    var dismissArrow : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    lazy var dislikeButton = self.createButton(image: UIImage(imageLiteralResourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: UIImage(imageLiteralResourceName: "like_circle"), selector: #selector(handleLike))
    lazy var superlikeButton = self.createButton(image: UIImage(imageLiteralResourceName: "super_like_circle"), selector: #selector(handleSuperlike))
    
    // userDeatil VC ında alttaki butonları benim belirlediğim parameterlerle oluşturacağım sıyala.
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }
    
    @objc fileprivate func handleDislike(){
        
    }
    @objc fileprivate func handleLike(){
        
    }
    @objc fileprivate func handleSuperlike(){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpLayout()
        setUpBlueVisualEffectView()
        setUpBottomControls()
        
    }
    
    fileprivate func setUpBottomControls(){
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 70))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setUpBlueVisualEffectView(){
        let bluerEffect = UIBlurEffect(style: .extraLight)
        let visualEffect = UIVisualEffectView(effect: bluerEffect)
        view.addSubview(visualEffect)
        visualEffect.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setUpLayout() {
        view.addSubview(scroolView)
        scroolView.fillSuperview()  // bu, bir extension method ile view un içerisinde konulmuş view un tamamına yayılmasını sağlar.
        scroolView.addSubview(personImageView)
        personImageView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.width)
        scroolView.addSubview(infoLabel)
        infoLabel.anchor(top: personImageView.bottomAnchor, leading: scroolView.leadingAnchor, bottom: nil, trailing: scroolView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        scroolView.addSubview(dismissArrow)
        dismissArrow.anchor(top: personImageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 25), size: .init(width: 50, height: 50))
    }
    
    /// !
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        // scrol edince person un photosu büyüsün.
        // frame ile ekrandaki View ların konumunu ve boyutunu ayarlayabiliyorsun güzelce.
        personImageView.frame = CGRect(x: -changeY, y: -changeY+20, width: view.frame.width + changeY*2, height: view.frame.width + changeY*2)
    }
    
    @objc fileprivate func dismissView(){
        self.dismiss(animated: true)
    }


}
