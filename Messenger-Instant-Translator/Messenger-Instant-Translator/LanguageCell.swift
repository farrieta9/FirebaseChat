//
//  LanguageCell.swift
//  Messenger-Instant-Translator
//
//  Created by Francisco Arrieta on 1/8/17.
//  Copyright © 2017 lil9porkchop. All rights reserved.
//

import UIKit

class LanguageCell: UICollectionViewCell {
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        label.textAlignment = .center
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(languageLabel)
        addSubview(separatorView)
        
        // need x, y, width, height
        languageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        languageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        languageLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        languageLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
