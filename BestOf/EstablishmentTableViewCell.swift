//
//  EstablishmentTableViewCell.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-25.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class EstablishmentTableViewCell: UITableViewCell {

    static let defaultCellHeight: CGFloat = 65
    static let expandedCellHeight: CGFloat = 200
    
    
    var isObserving = false

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
        label.font = UIFont(name: "System Font", size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address: 325 Cambie St, Vancouver, BC V6B 1H7"
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone: (604) 558-4444"
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Like", forState: .Normal)
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = UIColor.grayColor()
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    let dislikeButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Dislike", forState: .Normal)
        button.tintColor = UIColor.whiteColor()
        button.backgroundColor = UIColor.grayColor()
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    let buttonContainerView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.blueColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        
        //address label autolyaouts:
        addSubview(addressLabel)
        addressLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        addressLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: EstablishmentTableViewCell.defaultCellHeight + 15).active = true
        
        //address label autolyaouts:
        addSubview(phoneLabel)
        phoneLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        phoneLabel.topAnchor.constraintEqualToAnchor(addressLabel.bottomAnchor, constant: 10).active = true
        
        // container view autolayouts
        addSubview(buttonContainerView)
        buttonContainerView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        buttonContainerView.topAnchor.constraintEqualToAnchor(phoneLabel.bottomAnchor, constant: 10).active = true
        buttonContainerView.heightAnchor.constraintEqualToConstant(45).active = true
        buttonContainerView.widthAnchor.constraintEqualToConstant(200).active = true
        
        
        // like button autolyaouts:
        // x, y, height, width anchors:
        buttonContainerView.addSubview(likeButton)
        likeButton.leftAnchor.constraintEqualToAnchor(buttonContainerView.leftAnchor, constant: 10).active = true
        likeButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor, constant: 5).active = true
        likeButton.widthAnchor.constraintEqualToConstant(85).active = true
        
        
        // like button autolyaouts:
        // x, y, height, width anchors:
        buttonContainerView.addSubview(dislikeButton)
        dislikeButton.rightAnchor.constraintEqualToAnchor(buttonContainerView.rightAnchor, constant: 10).active = true
        dislikeButton.topAnchor.constraintEqualToAnchor(buttonContainerView.topAnchor, constant: 5).active = true
        dislikeButton.widthAnchor.constraintEqualToConstant(85).active = true
        
        
        
        
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
    }
    
    // MARK: Observer methods
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [.New, .Initial], context: nil)
            isObserving = true
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
        
    }
    
    // CHECK HEIGHT
    
    func checkHeight() {
        let booleanCheck = (frame.size.height < EstablishmentTableViewCell.expandedCellHeight)

        addressLabel.hidden = booleanCheck
        phoneLabel.hidden = booleanCheck
        buttonContainerView.hidden = booleanCheck
        
    }
    
    
    
    
    
    


}




