//
//  SwipingPhotosController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 5.06.2023.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    fileprivate var controllers = [UIViewController]()
    var cardViewModel : CardViewModel!{
        didSet {
            // mapping parantezleri arasında kıvrık parantezler içerisinde ne işlemi yapmasını belirtebileceğin kodlar yazabilirsin.
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                // imageUrls isimli değişken bir dizi ve mapping operasyonu her seferinde bir değeri alıyor, işliyor, yerine yerleştiriyor. Sen de bu mapping operasyonu bitince o dizi yi kullanıyorsun.
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers( [controllers.first!] , direction: .forward, animated: true)
            setUpBarViews()
        }
    }
    fileprivate var barStackView = UIStackView(arrangedSubviews: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
        
        // bu method dataSource dan gelen iki method un yanında ne yapıyor anlamadım.
        // setViewControllers( [controllers.first!] , direction: .forward, animated: true)
    }
    
    fileprivate func setUpBarViews(){
        // insanın photo su kadar bar görmek isterim.
        cardViewModel.imageUrls.map({ _ in
            let barView = UIView()
            barView.backgroundColor = .gray
            barView.layer.cornerRadius = 4
            barStackView.addArrangedSubview(barView)
        })
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barStackView)
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 3))
    }
    
    // swiping işlemi bittikten sonra çalışacak olan kodlar bu methodun içerisine yazılır.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            // '$0' dizi deki eşitliği sağlayan değerlerden ilkini seçebilmemizi sağlayan bir syntax dır.
            // az kodla çok iş yapmaya olanak tanıyor.
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = .gray})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    // bu iki method pageSwiping yapabilmek için gerekli method larmış.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // bu methodda viewController isimli parametre ekrandaki mevcut UIViewControler ı sana veriyor.
        // Ekranda göstermek istediğim her VC ı tuttuğum dizide onun yerini bulup, bir sankani VC ı döndürebiliyorum.
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }

}

class PhotoController: UIViewController {
    
    fileprivate var imageView = UIImageView(image: UIImage(named: "kelly1"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl){
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)  // bu super init i neden yazmam lazım anlamadım.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
