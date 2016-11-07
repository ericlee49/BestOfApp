//
//  EstablishmentRequestController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-10-02.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

class EstablishmentRequestController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categoryNames = [String]()
    
    let backItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        return barButton
    }()
    
    // USER ID:
    var userID: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
        
        navigationItem.title = "Request an Establishment"
        
        setupView()
        
        setupTextFieldDelegates()
        
        setupPicker()
        
        // Resign keyboard when view is tapped outside keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardWithTap))
        view.addGestureRecognizer(tapGesture)
        
        categoryName.delegate = self
        
        firebaseUserAuth()

    }
    
    func resignKeyboardWithTap() {
        if establishmentName.isFirstResponder == true {
            establishmentName.resignFirstResponder()
        } else if categoryName.isFirstResponder == true {
            categoryName.resignFirstResponder()
        } else if commentsTextField.isFirstResponder == true {
            commentsTextField.resignFirstResponder()
        } else {
            return
        }
    }
    
    func setupTextFieldDelegates() {
        establishmentName.delegate = self
        categoryName.delegate = self
        commentsTextField.delegate = self
    }
    
    func setupPicker() {
        categoryPicker.delegate = self
        
        // set the categoryName textfield's inputView from keyboard to category Picker
        categoryName.inputView = categoryPicker
        categoryName.inputAccessoryView = inputToolBar

    }
    
    func donePicker() {
        categoryName.resignFirstResponder()
        commentsTextField.becomeFirstResponder()
    }
    
    // MARK: Picker DataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryNames[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryName.text = self.categoryNames[row]
    }
    
    
    // MARK: Textfield Delegate Protocols
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.becomeFirstResponder()
        if textField === categoryName {
           let textIndexRow =  self.categoryPicker.selectedRow(inComponent: 0)
           textField.text = categoryNames[textIndexRow]
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField === self.establishmentName {
            self.categoryName.becomeFirstResponder()
            return true
        }
        
        return true
    }
    
    
    // MARK: Views
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.gray
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmitRequest), for: .touchUpInside)
        return button
    }()

    
    // establihsmentName textfield
    let establishmentName: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Enter an Establishment (e.g. Wendys)"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // category name textfield
    let categoryName: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Select a category for Establishment"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    // comments textfield
    let commentsTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "SFUIText-Regular", size: 18)
        textfield.placeholder = "Additional Comments."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // grey divider line between establishment-name & category
    let dividerLineEstablishmentToCategory: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // grey divider line between category & comment
    let dividerLineCategoryToComment: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Picker for categories
    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    
    lazy var inputToolBar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    

    
    
    // MARK: View Setup
    
    func setupView() {
        view.addSubview(textFieldContainer)
        
        // Autolayouts for textFieldContainerView 
        // x, y, height, width autolayout constraints
        textFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -55).isActive = true
        textFieldContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        textFieldContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        
        view.addSubview(submitButton)
        
        // Autolayouts for submit button
        // x, y, height, width autolayout constraints
        submitButton.centerXAnchor.constraint(equalTo: textFieldContainer.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 10).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor, multiplier: 1/2, constant: 1).isActive = true
        
        textFieldContainer.addSubview(establishmentName)
        establishmentName.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 10).isActive = true
        establishmentName.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 0).isActive = true
        establishmentName.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor, multiplier: 1/3, constant: 0).isActive = true
        establishmentName.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor, multiplier: 1, constant: -5).isActive = true
        
        textFieldContainer.addSubview(dividerLineEstablishmentToCategory)
        // x, y, height, width anchors:
        dividerLineEstablishmentToCategory.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor).isActive = true
        dividerLineEstablishmentToCategory.topAnchor.constraint(equalTo: establishmentName.bottomAnchor, constant: -2).isActive = true
        dividerLineEstablishmentToCategory.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        dividerLineEstablishmentToCategory.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor).isActive = true
        
        textFieldContainer.addSubview(categoryName)
        categoryName.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 10).isActive = true
        categoryName.topAnchor.constraint(equalTo: establishmentName.bottomAnchor).isActive = true
        categoryName.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor, multiplier: 1/3, constant: 0).isActive = true
        categoryName.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor, multiplier: 1, constant: -5).isActive = true
        
        textFieldContainer.addSubview(commentsTextField)
        commentsTextField.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 10).isActive = true
        commentsTextField.topAnchor.constraint(equalTo: categoryName.bottomAnchor).isActive = true
        commentsTextField.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor, multiplier: 1/3, constant: 0).isActive = true
        commentsTextField.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor, multiplier: 1, constant: -5).isActive = true
        
        textFieldContainer.addSubview(dividerLineCategoryToComment)
        // x, y, height, width anchors:
        dividerLineCategoryToComment.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor).isActive = true
        dividerLineCategoryToComment.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: -2).isActive = true
        dividerLineCategoryToComment.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        dividerLineCategoryToComment.widthAnchor.constraint(equalTo: textFieldContainer.widthAnchor).isActive = true
        
    }
    
    // MARK: FIREBASE
    
    func handleSubmitRequest() {
        guard
            let establishment = establishmentName.text,
            let category = categoryName.text,
            !establishment.isEmpty && !category.isEmpty else{
                failureAlert()
                return
        }
        
        let ref = FIRDatabase.database().reference()
        let childRef = ref.child("establishmentRequests")
        let requestReference = childRef.childByAutoId()
        let values: [String:String]
        
        if commentsTextField.text!.isEmpty {
            values = [ "establishmentName": establishment, "categoryName": category, "comments": "None", "user": userID]
        } else {
            values = [ "establishmentName": establishment, "categoryName": category, "comments": commentsTextField.text!,"user": userID]
        }
        
        
        requestReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.successAlert()
        }
    }
    
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
    
    // MARK: Alerts
    
    func failureAlert() {
        let alert = UIAlertController(title: "Incomplete", message: "Could not Submit Request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "Successfully submitted request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
