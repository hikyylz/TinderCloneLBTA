//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupdummyCards()
        
    }
    
    fileprivate func setupdummyCards(){
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    
    
    
    // MARK: - Fileprivate func  extracted method
    fileprivate func setupLayout() {
        // SwiftUI özellikleri ama eski versiyonu bu galiba.
        let overAllStackview = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, BottomSubviews])
        overAllStackview.axis = .vertical
        view.addSubview(overAllStackview)
        overAllStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        // ekrandaki layout düzeltmelerini sıfırlamak için alttaki satır a ihtiyacım varmış.
        overAllStackview.isLayoutMarginsRelativeArrangement = true
        
        // overallStackView umun değerlerini girdim lakin sadece card View um istediğim değerde oldu, bunun sebebi diğer view ların nasıl gözükeceğini önceden belirtmiştim.
        overAllStackview.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        // isminden belli ne olduğu.
        overAllStackview.bringSubviewToFront(cardsDeckView)
    }


}

