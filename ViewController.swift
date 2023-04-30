//
//  ViewController.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 30.04.2023.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let BottomSubviews = HomeButtonControlStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        extractedFunc()
        
    }
    
    // MARK: - Fileprivate func  extracted method
    fileprivate func extractedFunc() {
        // SwiftUI özellikleri ama eski versiyonu bu galiba.
        let overAllStackview = UIStackView(arrangedSubviews: [topStackView, blueView, BottomSubviews])
        overAllStackview.axis = .vertical
        view.addSubview(overAllStackview)
        overAllStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

