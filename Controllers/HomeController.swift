//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    
    // ekranda gözükmesini istediğim her şeyin tanımlandığı yer burasıdır.
    // burda gösterebileceğim her şey ProducesCardViewModel ine uymak zorunda.
    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsersFromFirebase()
    }
    
    fileprivate func fetchUsersFromFirebase(){
        
        // bu işlemler async await işlemler.. dikkatli ol neyi ne sırayla yaptığına.
        Firestore.firestore().collection("users").getDocuments { snapShot, err in
            if let _ = err{
                // failed fetching user from firebase.
                return
            }
            
            guard let snapShot = snapShot else {return}
            snapShot.documents.forEach({ documentSnapShot in
                let userDictionary = documentSnapShot.data()
                let fetchedUser = User(dictionary: userDictionary)
                self.cardViewModels.append(fetchedUser.toCardViewModel())
            })
            self.setupdummyCards()
        }
    }
    
    @objc fileprivate func handleSettings(){
        let RegisterationViewController = RegisterationViewController()
        present(RegisterationViewController, animated: true)
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

