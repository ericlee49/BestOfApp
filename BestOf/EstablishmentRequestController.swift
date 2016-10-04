//
//  EstablishmentRequestController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-10-02.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class EstablishmentRequestController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categoryNames = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
        
        navigationItem.title = "Request an Establishment"
        
        print(self.categoryNames)
        
        setupView()
        
        setupTextFieldDelegates()
        
        setupPicker()
        
        // Resign keyboard when view is tapped outside keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardWithTap))
        view.addGestureRecognizer(tapGesture)
        
        categoryName.delegate = self

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === categoryName {
            textField.text = categoryNames[0]
        }
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
        
        
        /*
        // autolayouts for picker bar
        categoryPicker.addSubview(pickerBar)
        
        pickerBar.leftAnchor.constraint(equalTo: categoryPicker.leftAnchor).isActive = true
        pickerBar.topAnchor.constraint(equalTo: categoryPicker.topAnchor).isActive = true
        pickerBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pickerBar.widthAnchor.constraint(equalTo: categoryPicker.widthAnchor).isActive = true
        
        pickerBar.addSubview(doneButton)
        doneButton.rightAnchor.constraint(equalTo: pickerBar.rightAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: pickerBar.topAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: pickerBar.widthAnchor, multiplier: 1/3).isActive = true
        doneButton.heightAnchor.constraint(equalTo: pickerBar.heightAnchor).isActive = true
        */
    }
    
    func donePicker() {
        
        categoryName.resignFirstResponder()
        
        commentsTextField.becomeFirstResponder()
        
        print("Done Done")
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
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
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
    
    /*
    
    // Picker Bar view
    let pickerBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    // Picker Bar Done button
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    */
    
    lazy var inputToolBar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        
        toolbar.setItems([doneButton], animated: true)
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
        textFieldContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        textFieldContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
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
    
    
    
}
