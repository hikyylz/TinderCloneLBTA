//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    var lastFetchedUser : User?    // pagination özelliğini kullanırken kaldığım user ı tütmak için var bu değişken.
    
    // ekranda gözükmesini istediğim her şeyin tanımlandığı yer burasıdır.
    // burda gösterebileceğim her şey ProducesCardViewModel ine uymak zorunda.
    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        BottomSubviews.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsersFromFirebase()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirebase()
    }
    
    fileprivate func fetchUsersFromFirebase(){
        let fetcingUserHUD = JGProgressHUD(style: .dark)
        fetcingUserHUD.textLabel.text = "People coming.."
        fetcingUserHUD.show(in: self.view)
        
        // bu işlemler async await işlemler.. dikkatli ol neyi ne sırayla yaptığına.
        // pagination özelliği için quey de özelleştire yapıyoruz.
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { snapShot, err in
            
            fetcingUserHUD.dismiss(animated: false)
            
            if let _ = err{
                // failed fetching user from firebase.
                return
            }
            
            guard let snapShot = snapShot else {return}
            snapShot.documents.forEach({ documentSnapShot in
                let userDictionary = documentSnapShot.data()
                let fetchedUser = User(dictionary: userDictionary)
                // self.cardViewModels.append(fetchedUser.toCardViewModel())
                self.lastFetchedUser = fetchedUser      // foreach den çıkmadan önce son user atanır.
                self.setUpCardsDeckViewFromUser(user: fetchedUser)
            })
            //   self.setupFirestoreUserCards()
        }
    }
    
    @objc fileprivate func handleSettings(){
        let RegisterationViewController = RegisterationViewController()
        RegisterationViewController.modalPresentationStyle = .fullScreen
        present(RegisterationViewController, animated: true)
    }
    
    fileprivate func setUpCardsDeckViewFromUser(user: User){
        // cardView taslağı oluştur..
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        self.cardsDeckView.addSubview(cardView)
        self.cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()    // view u içene koyduğum view un boyutunu alsın tam olarak diye kullandığı enfes bir method.
    }
    
    // "fetchUsersFromFirebase" methodunun son satırlarında bunu çalıştırmak pagination işlemime set vuruyordu, eski fetch ettiğim değerleri görmeye devam ediyordum. onun yerine başka bir methodla hallettim. Projenin başında elle oluşturduğum user ları şimdi cloud dan fetch ettiğim için 'cardViewModels' a ihtiyacım kalmadı. bu method boşa çıktı.
    fileprivate func setupFirestoreUserCards(){
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
    
    
    
    
    // MARK: - Fileprivate func extracted method
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

