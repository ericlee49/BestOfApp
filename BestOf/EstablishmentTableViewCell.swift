//
//  EstablishmentTableViewCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-25.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class EstablishmentTableViewCell: UITableViewCell {

    


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(percentRatingLabel)
        
        setUpViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let percentRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "89%"
        label.font = UIFont(name: "System Font", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setUpViews() {
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
    }
    
    

    
    /*

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "MOMOFUKU"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
