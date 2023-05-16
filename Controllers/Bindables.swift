//
//  Bindables.swift
//  TinderCloneLBTA
//
//  Created by Kaan Yıldız on 15.05.2023.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    // bu closure un anında çalışması lazım değil mi yaaa diye düşünüyorsa dostum, hayır değil. @escaping yapısıyla async olarak tanımlandığı yerden parametre olarak alıyoruz değeri ve çalıştırıyoruz.
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
