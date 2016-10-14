//
//  Extensions.swift
//  Courier
//
//  Created by Francisco Arrieta on 8/19/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

extension UIColor {	
	convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
		self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
	}
}

//let imageCache = NSCache()  // Rename to cachedImages
var imageCache = [String: AnyObject]()

extension UIImageView {
    func loadImageUsingURLString(_ urlString: String) {
        let url = URL(string: urlString)
        
        image = nil
        image = UIImage(named: "default_profile.png")
        
        /*
         if let imageFromCache = imageCache.object(forKey: urlString) as? UIImage {
         self.image = imageFromCache
         return
         }
         */
        
        if let imageFromCache = imageCache[urlString] as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if urlString == "" {
            return // has no image in firebase
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                
                let imageToCache = UIImage(data: data!)
                
                //imageCache.setObject(imageToCache!, forKey: urlString)
                imageCache[urlString] = imageToCache
                
                self.image = imageToCache
            })
        }) .resume()
    }
}
extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension UIView {
	func addConstraintsWithFormat(_ format: String, views: UIView...) {
		var viewsDictionary = [String: UIView]()
		for (index, view) in views.enumerated() {
			let key = "v\(index)"
			view.translatesAutoresizingMaskIntoConstraints = false
			viewsDictionary[key] = view
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
	}
}
