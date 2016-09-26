//
//  CategoryRequestViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-22.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

class CategoryRequestViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
        
        navigationItem.title = "Request a Category"
        
        handleContainerLayout()
        
        handleSubmitButtonLayout()
        
        categoryName.delegate = self
        additionalComments.delegate = self
        
        // Resign keyboard when view is tapped outside keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardWithTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    // MARK: Views
    
    // container view
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    // submit request button
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Submit", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()

    // category name textfield
    let categoryName: UITextField = {
        let textfield = UITextField()
        //textfield.backgroundColor = UIColor.greenColor()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Enter a category (e.g. Best milkshakes)"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    // additional comments textView
    let additionalComments: UITextView = {
        let textView = UITextView()
        textView.text = "Add additional comments here:"
        textView.returnKeyType = UIReturnKeyType.Done
        //textView.backgroundColor = UIColor.blueColor()
        textView.textColor = UIColor.lightGrayColor()
        textView.font = UIFont(name: textView.font!.fontName, size: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // placeholder text for additional comments view
    
    
    
    // grey divider line between two textfields
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Autolayout of Views
    
    func handleContainerLayout() {
        
        view.addSubview(containerView)
        // x, y, height, width anchors:
        containerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        containerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -50).active = true
        containerView.heightAnchor.constraintEqualToConstant(200).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1, constant: -20).active = true
        
        containerView.addSubview(categoryName)
        // x, y, height, width anchors:
        categoryName.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 10).active = true
        categoryName.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 0).active = true
        categoryName.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor, multiplier: 1/3, constant: 0).active = true
        categoryName.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, multiplier: 1, constant: -5).active = true
        
        containerView.addSubview(dividerLine)
        // x, y, height, width anchors:
        dividerLine.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 0).active = true
        dividerLine.topAnchor.constraintEqualToAnchor(categoryName.bottomAnchor, constant: -2).active = true
        dividerLine.heightAnchor.constraintEqualToConstant(0.75).active = true
        dividerLine.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        
        containerView.addSubview(additionalComments)
        // x, y, height, width anchors:
        additionalComments.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        additionalComments.topAnchor.constraintEqualToAnchor(categoryName.bottomAnchor, constant: 0).active = true
        additionalComments.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor, multiplier: 2/3, constant: 0).active = true
        additionalComments.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, multiplier: 1, constant: -15).active = true
        
        
        
    }
    
    func handleSubmitButtonLayout() {
        view.addSubview(submitButton)
        // x, y, height, width anchors:
        submitButton.centerXAnchor.constraintEqualToAnchor(containerView.centerXAnchor).active = true
        submitButton.topAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: 10).active = true
        submitButton.heightAnchor.constraintEqualToConstant(50).active = true
        submitButton.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, multiplier: 1/2, constant: 1).active = true
    }
    
    
    // MARK: Action (FIREBASE)
    
    func handleSubmit() {
        print("submitting to firebase")
        let ref = FIRDatabase.database().reference()
        let childRef = ref.child("categoryRequests")
        let requestReference = childRef.childByAutoId()
        
        guard let category = categoryName.text, comments = additionalComments.text where !category.isEmpty && !comments.isEmpty else{
            //FAILURE ALERT:
            print("failed to submit to firebase")
            return
        }
        
        let values = [ "categoryName:": category, "comments": comments]
        
        requestReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            print("successfully submitted request")
        }
        
    }
    
    // MARK: TextField Delegate protocols
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === self.categoryName {
            self.additionalComments.becomeFirstResponder()
            
        }
        return true
    }
    
    
    // MARK: TextView Delegate protocols
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add additional comments here:"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    
    // MARK: helper methods
    
    func resignKeyboardWithTap() {
        if self.categoryName.isFirstResponder() == true {
            self.categoryName.resignFirstResponder()
            return
        }
        if self.additionalComments.isFirstResponder() == true {
            self.additionalComments.resignFirstResponder()
            return
        }
        
 
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "Succesfully logged in", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alert: UIAlertAction) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


    
}
