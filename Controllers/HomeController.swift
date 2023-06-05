//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit
import Firebase
import JGProgressHUD


extension HomeController: SettingsControllerDelegate{
    func didSaveSettings() {
        self.fetchCurrentUser()
    }
}

extension HomeController: LoginControllerDelegate{
    func didFinishLoggingIn() {
        self.fetchCurrentUser()
    }
}

extension HomeController: CardviewDelegate{
    
    func didTappedMoreInfo(cardViewModel: CardViewModel) {
        let userDetailController = UserDetailsViewController()
        userDetailController.userCardViewModel = cardViewModel
        userDetailController.modalPresentationStyle = .fullScreen
        present(userDetailController, animated: true)
    }
}

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    var lastFetchedUser : User?    // pagination özelliğini kullanırken kaldığım user ı tutmak için var bu değişken.
    fileprivate var currentUser : User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        BottomSubviews.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // uygulama açıldığında login olmuş olan user yoksa registerController a git.
        if Auth.auth().currentUser == nil{
            let Registrationcontroller = RegisterationViewController()
            let navController = UINavigationController(rootViewController: Registrationcontroller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    fileprivate func fetchCurrentUser(){
        // current user ın settings bilgilerini almam gerek..
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapShot, err in
            if let err = err{
                print(err)
                return
            }
            
            guard let userData = snapShot?.data() as? [String : Any] else {return}
            self.currentUser = User(dictionary: userData)
            self.fetchUsersFromFirebase()
        }
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirebase()
    }
    
    fileprivate func fetchUsersFromFirebase(){
        // homeView da current user ın kriterler koyduğu insanlar gözüksün işlemleri..
        guard let minAge = currentUser?.minSeekingAge, let maxAge = currentUser?.maxSeekingAge else{
            return
        }
        
        let fetcingUserHUD = JGProgressHUD(style: .dark)
        fetcingUserHUD.textLabel.text = "People coming.."
        fetcingUserHUD.show(in: self.view)
        
        // bu işlemler async await işlemler.. dikkatli ol neyi ne sırayla yaptığına.
        // pagination özelliği için quey de özelleştire yapıyoruz.
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
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
                self.lastFetchedUser = fetchedUser      // foreach den çıkmadan önce son user atanır.
                // kendimi swap lamak istemiyorum.
                if self.currentUser?.uid != fetchedUser.uid{
                    self.setUpCardsDeckViewFromUser(user: fetchedUser)
                }
            })
        }
    }
    
    @objc fileprivate func handleSettings(){
        let SettingsController = SettingsController()
        SettingsController.delegate = self
        // navigationController özelliklerini üzerinde uygulamak istediğim VC a bağlıyorum.
        let navController = UINavigationController(rootViewController: SettingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    fileprivate func setUpCardsDeckViewFromUser(user: User){
        // cardView taslağı oluştur..
        let cardView = CardView(frame: .zero)
        cardView.delegate = self         // delegation işleminde bu satırı yazmayı unutmasaydın güzel olurdu.
        cardView.cardViewModel = user.toCardViewModel()
        self.cardsDeckView.addSubview(cardView)
        self.cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()    // view u içene koyduğum view un boyutunu alsın tam olarak diye kullandığı enfes bir method.
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

