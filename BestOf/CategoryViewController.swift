//
//  ViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-08-23.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

// MARK: MODEL
struct Categories {
    var name: String?
    var imageName: String?
}




// MARK: CONTROLLER
class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categoriesArray = [Categories]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BestOf Vancouver"
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        
        collectionView?.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
        createCategories()
        
        createNavigationBarSettingsButton()
        
        
        
    }
    
    func createNavigationBarSettingsButton() {
        
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(showSettingsView))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    func showSettingsView() {
        print(123)
        let settings = SettingsCollectionViewController()
        settings.showSettings()
        
    }
    
    func createCategories() {
        
        let coffee = Categories(name: "Coffee", imageName: "coffee")
        
        let ramen = Categories(name: "Ramen", imageName: "ramen")
        
        let iceCream = Categories(name: "Ice Cream", imageName: "icecream")
        
        categoriesArray += [coffee, ramen, iceCream]
    }
    
    // MARK: CollectionView Data source, Delegate Protocols
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCellWithReuseIdentifier(customCellIdentifier, forIndexPath: indexPath) as! CustomCell
        customCell.nameLabel.text = categoriesArray[indexPath.item].name
        customCell.categoryImageView.image = UIImage(named: categoriesArray[indexPath.item].imageName!)
        return customCell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        let tableViewController = EstablishmentsInCategoryTableViewController()
        navigationController?.pushViewController(tableViewController, animated: true)
        
        
        
    }
    
    func setUpEstablishments() -> [Establishment]{
        
        let jinya = Establishment(name: "Jinya", inCategory: "ramen")
        let applause = Establishment(name: "Applause Sushi", inCategory: "ramen")
        
        return [jinya, applause]
        
    }
    
    
    // MARK: CollectionView Spacing & Sizing
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5 , height: collectionView.frame.width/2 - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }

}





class CustomCell: UICollectionViewCell {
    
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
        
        
        
    }
    
}
