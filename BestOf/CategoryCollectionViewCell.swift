//
//  CategoryCollectionViewCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-13.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        
    }
    
    override var highlighted: Bool {
        didSet {
            backgroundColor = highlighted ? UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1) : nil
            nameLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
        }
    }
    
    // category ImageView
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.borderColor = UIColor.grayColor().CGColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium" , size: 18)
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        //backgroundColor = UIColor.blueColor()
        
        addSubview(categoryImageView)
        //categoryImageView.image = UIImage(named: "ramen")
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v0(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":categoryImageView]))
        
        
        addConstraint(NSLayoutConstraint(item: categoryImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-17-[v0(150)]-4-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":categoryImageView, "v1":nameLabel]))
        
        // Adding indicator view
        addSubview(activityIndicator)
        // autolayouts for activity indicator
        activityIndicator.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        
        
        
    }
}
