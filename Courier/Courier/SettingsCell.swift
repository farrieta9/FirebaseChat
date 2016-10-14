//
//  SettingsCell.swift
//  SongBar
//
//  Created by Francisco Arrieta on 7/14/16.
//  Copyright © 2016 lil9porkchop. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
	
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
			nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
		}
	}
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Settings"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 16)
		return label
	}()
	
	var setting: Setting? {
		didSet {
			nameLabel.text = setting?.name
		}
	}
	
	override func setUpViews() {
		super.setUpViews()
		addSubview(nameLabel)
		
		addConstraintsWithFormat("H:|[v0]|", views: nameLabel)  // Expands from left edge to right edge
		addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
	}
}
