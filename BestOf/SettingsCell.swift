//
//  SettingsCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-11.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            self.nameLabel.text = setting?.name.rawValue
            
            if let iconImage = setting?.imageName {
                self.iconImageView.image = UIImage(named: iconImage)?.withRenderingMode(.alwaysTemplate)
                self.iconImageView.tintColor = UIColor.darkGray

            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings Test"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "account")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    
    func setupViews() {
        //backgroundColor = UIColor.redColor()
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: (8 + 25 + 15)).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
