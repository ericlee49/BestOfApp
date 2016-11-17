//
//  CategoryRequestViewController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-22.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

class CategoryRequestViewController: UIViewController, UITextFieldDelegate {
    
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
        
        firebaseUserAuth()
        
    }
    
    
    var userID = ""
    
    let backItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        return barButton
    }()
    
    
    // MARK: Views
    
    // container view
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    // submit request button
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("Submit", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmit), for: UIControlEvents.touchUpInside)
        return button
    }()

    // category name textfield
    let categoryName: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Enter a category (e.g. Best milkshakes)"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    // comments textfield
    let additionalComments: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Add additional comments here:"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    // grey divider line between two textfields
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Autolayout of Views
    
    func handleContainerLayout() {
        
        view.addSubview(containerView)
        // x, y, height, width anchors:
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -20).isActive = true
        
        containerView.addSubview(categoryName)
        // x, y, height, width anchors:
        categoryName.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        categoryName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        categoryName.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2, constant: 0).isActive = true
        categoryName.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1, constant: -5).isActive = true
        
        containerView.addSubview(dividerLine)
        // x, y, height, width anchors:
        dividerLine.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        dividerLine.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: -2).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        dividerLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(additionalComments)
        // x, y, height, width anchors:
        additionalComments.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        additionalComments.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 0).isActive = true
        additionalComments.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2, constant: 0).isActive = true
        additionalComments.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1, constant: -5).isActive = true
        
        
        
    }
    
    func handleSubmitButtonLayout() {
        view.addSubview(submitButton)
        // x, y, height, width anchors:
        submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/2, constant: 1).isActive = true
    }
    
    
    // MARK: Action (FIREBASE)
    
    func handleSubmit() {
        print("submitting to firebase")
        let ref = FIRDatabase.database().reference()
        let childRef = ref.child("categoryRequests")
        let requestReference = childRef.childByAutoId()
        
        guard let category = categoryName.text, let comments = additionalComments.text , !category.isEmpty && !comments.isEmpty else{
            //FAILURE ALERT:
            print("failed to submit to firebase")
            return
        }
        
        let values = [ "categoryName:": category, "comments": comments]
        
        requestReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            print("successfully submitted request")
        }
        
    }
    
    // MARK: TextField Delegate protocols
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField === self.categoryName {
            self.additionalComments.becomeFirstResponder()
            
        }
        return true
    }
    
    
    
    // MARK: helper methods
    
    func resignKeyboardWithTap() {
        if self.categoryName.isFirstResponder == true {
            self.categoryName.resignFirstResponder()
            return
        }
        if self.additionalComments.isFirstResponder == true {
            self.additionalComments.resignFirstResponder()
            return
        }
        
 
    }
    
    // MARK: Alerts
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "Succesfully logged in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Firebase AUTH:
    func firebaseUserAuth() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                print("USER HERE:::::::::::")
                print(user.uid)
                self.userID = user.uid
            } else {
                self.loginRegisterAlert()
                //return
            }
        }
    }
    
    func loginRegisterAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "Please login/register before making a request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) in
            self.showLoginViewController()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showLoginViewController() {
        
        navigationItem.backBarButtonItem = self.backItem
        
        let loginViewController = LoginViewController()
        //presentViewController(loginViewController, animated: true, completion: nil)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    


    
}
