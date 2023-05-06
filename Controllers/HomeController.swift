//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    
    // ekranda ortada gözükmesini istediğim her şeyin tanımlandığı yer burasıdır.
    // burda gösterebileceğim her şey ProducesCardViewModel ine uymak zorunda.
    let cardViewModels : [CardViewModel] = {
       let producers = [
        User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["kelly1" , "kelly2"]),
        User(name: "Kenny", age: 23, profession: "music DJ", imageNames: ["jane1" , "jane2" , "jane3"]),
        Advertiser(title: "Slide Out menu feature", bradnName: "LBTA", posterPhotoName: ["slide_out_menu_poster"])
        
       ] as [ProducesCardViewModel]
                                        
        let viewModels = producers.map({ return $0.toCardViewModel() })
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupdummyCards()
        
    }
    
    fileprivate func setupdummyCards(){
        cardViewModels.forEach { cardVM in
            // cardView taslağı oluştur..
            let cardView = CardView(frame: .zero)
            
            // taslağa değerler yerleştir..
            cardView.cardViewModel = cardVM
            
            // oluşturulan view u ekranda gözükecek viewun içine yerleştirelim.
            self.cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
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

