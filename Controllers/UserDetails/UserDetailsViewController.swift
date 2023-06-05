//
//  UserDetailsViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 3.06.2023.
//

import UIKit

class UserDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    lazy var scroolView : UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .green
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never  // ekranın üzerinde boşluk yaratma!
        sv.delegate = self
        return sv
    }()
    let personImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kelly1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let infoLabel : UILabel = {
        let il = UILabel()
        il.text = "user name\nkaan\nuser age\n23"
        il.numberOfLines = 0   // bu atribute biraz sıkıntılıymış.
        return il
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissView)))
        view.addSubview(scroolView)
        scroolView.fillSuperview()  // bu, bir extension method ile view un içerisinde konulmuş view un tamamına yayılmasını sağlar.
        scroolView.addSubview(personImageView)
        personImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scroolView.addSubview(infoLabel)
        infoLabel.anchor(top: personImageView.bottomAnchor, leading: scroolView.leadingAnchor, bottom: nil, trailing: scroolView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        // scrol edince person un photosu büyüsün.
        // frame ile ekrandaki View ların konumunu ve boyutunu ayarlayabiliyorsun güzelce.
        personImageView.frame = CGRect(x: -changeY, y: -changeY, width: view.frame.width + changeY*2, height: view.frame.width + changeY*2)
    }
    
    @objc fileprivate func dismissView(){
        self.dismiss(animated: true)
    }


}
