//
//  LanguageController.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 1/8/17.
//  Copyright © 2017 lil9porkchop. All rights reserved.
//

import UIKit

class LanguageController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    var languages = [Languages]()
    var languages: [Languages] = {
        let english = Languages.English
        let spanish = Languages.Spanish
        let german = Languages.German
        return [english, spanish, german]
    }()
    
    var chatLogController: ChatLogController?
    
    private let cellId = "cellId"
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.isScrollEnabled = false
        return cv
    }()
    
    private let cellHeight: CGFloat = 40
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(LanguageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func showLanguages() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleDismissLanguage)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            let width = window.frame.width / 3
            self.collectionView.frame = CGRect(x: window.frame.width, y: 0, width: 0, height: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: { 
                self.blackView.alpha = 1
                
                let height = self.cellHeight * CGFloat(self.languages.count)
                
                self.collectionView.frame = CGRect(x: window.frame.width - width - 16, y: self.chatLogController!.heightOfNavigationBar + 20, width: width, height: height)
                
            }, completion: nil)
    
        }
    }

    func handleDismissLanguage() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: window.frame.width, y: 0, width: 0, height: 0)
            }
            
            
        }) { (completed: Bool) in
            self.chatLogController?.inputContainerView.isHidden = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LanguageCell
        cell.languageLabel.text = languages[indexPath.item].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}






