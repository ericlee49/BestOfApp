//
//  EstablishmentTableViewCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-25.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class EstablishmentTableViewCell: UITableViewCell {

    static var defaultCellHeight: CGFloat = 60
    static var expandedCellHeight: CGFloat = 200

    // Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(percentRatingLabel)
        
        setUpViews()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Views
    
    let percentRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "System Font", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST TEXT"
        //label.backgroundColor = UIColor.blueColor()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "$$$$$"
        //label.backgroundColor = UIColor.blueColor()
        label.font = UIFont(name: "System Font", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    func setUpViews() {
        
        
        // name label autolayouts:
        // x, y, height, width anchors:
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        nameLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        //nameLabel.heightAnchor.constraintEqualToConstant(25).active = true
        //nameLabel.widthAnchor.constraintEqualToConstant(80).active = true
        
        // price range label autolyaouts:
        // x, y, height, width anchors:
        addSubview(priceRangeLabel)
        priceRangeLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        priceRangeLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 2).active = true

        
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
    }
    
    

    
    /*

    
    let percentRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "89%"
        label.font = UIFont(name: "System Font", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews() {
        
        backgroundColor = UIColor.redColor()
        
        addSubview(nameLabel)
        addSubview(percentRatingLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-7-[v0][v1]-7-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":percentRatingLabel]))
        //addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-35-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-35-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
    }
 
 */

}
