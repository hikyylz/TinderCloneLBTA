//
//  SwipingPhotosController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 5.06.2023.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        
        let controllers = [
            redVC
        ]
        
        // bu method dataSource dan gelen iki method un yanında ne yapıyor anlamadım.
        setViewControllers(controllers, direction: .forward, animated: true)
    }
    
    
    // bu iki method pageSwiping yapabilmek için gerekli method larmış.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return PhotoController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return PhotoController()
    }

}

class PhotoController: UIViewController {
    
    let imageView : UIImageView
    
    init(image: UIImage) {
        self.imageView = UIImageView(image: image) 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
