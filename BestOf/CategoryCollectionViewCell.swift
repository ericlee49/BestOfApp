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
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1) : nil
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    // category ImageView
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.borderColor = UIColor.gray.cgColor
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
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
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
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":categoryImageView]))
        
        
        addConstraint(NSLayoutConstraint(item: categoryImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-17-[v0(150)]-4-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":categoryImageView, "v1":nameLabel]))
        
        // Adding indicator view
        addSubview(activityIndicator)
        // autolayouts for activity indicator
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
    }
}
