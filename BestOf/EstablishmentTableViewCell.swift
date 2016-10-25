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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
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
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "loading..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Like", for: UIControlState())
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
        
    }()
    
    let dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dislike", for: UIControlState())
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //nameLabel.heightAnchor.constraintEqualToConstant(25).active = true
        //nameLabel.widthAnchor.constraintEqualToConstant(80).active = true
        
        // price range label autolyaouts:
        // x, y, height, width anchors:
        addSubview(priceRangeLabel)
        priceRangeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        priceRangeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        
        //address label autolyaouts:
        addSubview(addressLabel)
        addressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: EstablishmentTableViewCell.defaultCellHeight + 15).isActive = true
        
        //address label autolyaouts:
        addSubview(phoneLabel)
        phoneLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        
        // container view autolayouts
        addSubview(buttonContainerView)
        buttonContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonContainerView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buttonContainerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        // like button autolyaouts:
        // x, y, height, width anchors:
        buttonContainerView.addSubview(likeButton)
        likeButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 10).isActive = true
        likeButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 5).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        
        // like button autolyaouts:
        // x, y, height, width anchors:
        buttonContainerView.addSubview(dislikeButton)
        dislikeButton.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor, constant: 10).isActive = true
        dislikeButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 5).isActive = true
        dislikeButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        
        
        
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":percentRatingLabel]))
        
    }
    
    // MARK: Observer methods
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [.new, .initial], context: nil)
            isObserving = true
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
        
    }
    
    // CHECK HEIGHT
    
    func checkHeight() {
        let booleanCheck = (frame.size.height < EstablishmentTableViewCell.expandedCellHeight)
        
        addressLabel.isHidden = booleanCheck
        phoneLabel.isHidden = booleanCheck
        buttonContainerView.isHidden = booleanCheck
        
        if booleanCheck {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
        
    }
    

    
    
    


}




