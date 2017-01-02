//
//  Extensions.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 12/25/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

var imageCache = [String: AnyObject]()

extension UIImageView {
    func loadImageUsingURLString(_ urlString: String) {
        let url = URL(string: urlString)
        
        image = nil
        image = UIImage(named: "default_profile.png")
        
        if let imageFromCache = imageCache[urlString] as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if urlString == "" {
            return // has no image in firebase
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                //imageCache.setObject(imageToCache!, forKey: urlString)
                imageCache[urlString] = imageToCache
                
                self.image = imageToCache
            })
        }).resume()
    }
}

extension UserDefaults {
    
    enum UserDefaultKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
