//
//  SettingsCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-11.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    
    override var highlighted: Bool {
        didSet {
            backgroundColor = highlighted ? UIColor.darkGrayColor() : UIColor.whiteColor()
            nameLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
            iconImageView.tintColor = highlighted ? UIColor.whiteColor() : UIColor.darkGrayColor()
        }
    }
    
    var setting: Setting? {
        didSet {
            self.nameLabel.text = setting?.name
            
            if let iconImage = setting?.imageName {
                self.iconImageView.image = UIImage(named: iconImage)?.imageWithRenderingMode(.AlwaysTemplate)

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
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    
    let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "account")
        icon.contentMode = .ScaleAspectFill
        return icon
    }()
    
    
    func setupViews() {
        //backgroundColor = UIColor.redColor()
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        iconImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        iconImageView.widthAnchor.constraintEqualToConstant(30).active = true
        iconImageView.heightAnchor.constraintEqualToConstant(30).active = true
        
        
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // x,y,width,height anchors
        nameLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: (8 + 25 + 15)).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        nameLabel.widthAnchor.constraintEqualToConstant(200).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(20).active = true
    }
}
