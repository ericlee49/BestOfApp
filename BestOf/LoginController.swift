//
//  LoginController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-13.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
        self.navigationItem.title = "Login/Register"
        
        view.addSubview(inputsViewContainerView)
        view.addSubview(loginButton)
        setupContainerView()
        setupLoginButton()
        
    }
    
    

    // MARK: Views
    
    let inputsViewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        //view.layer.masksToBounds = true
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(red: 145/255, green: 3/255, blue: 3/255, alpha: 1)
        button.setTitle("Login", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    
    }()
    
    let nameTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email Address"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.secureTextEntry = true
        return textField
    }()
    
    
    let nameToEmailDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let emailToPasswordDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: Views setup & autolayouts
    
    func setupContainerView() {
        
        // Autolayout inputsViewContainerView
        // x, y, width, height constraints
        let inputsViewContainerHeight: CGFloat = 150
        inputsViewContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsViewContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsViewContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -25).active = true
        inputsViewContainerView.heightAnchor.constraintEqualToConstant(inputsViewContainerHeight).active = true
        
        // Add nameTextField to container & autolayout
        inputsViewContainerView.addSubview(nameTextField)
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsViewContainerView.topAnchor).active = true
        nameTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        nameTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3).active = true
        
        // Add emailTextField to container & autolayout
        inputsViewContainerView.addSubview(emailTextField)
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        emailTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3).active = true
        
        // Add passwordTextField to container & autolayout
        inputsViewContainerView.addSubview(passwordTextField)
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        passwordTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3).active = true
        
        // Add nameToEmailDividerLine to container & autolayout
        inputsViewContainerView.addSubview(nameToEmailDividerLine)
        // x, y, width, height constraints
        nameToEmailDividerLine.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor).active = true
        nameToEmailDividerLine.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameToEmailDividerLine.widthAnchor.constraintEqualToAnchor(inputsViewContainerView.widthAnchor).active = true
        nameToEmailDividerLine.heightAnchor.constraintEqualToConstant(1).active = true
        
        // Add emailToPasswordDividerLine to container & autolayout
        inputsViewContainerView.addSubview(emailToPasswordDividerLine)
        // x, y, width, height constraints
        emailToPasswordDividerLine.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor).active = true
        emailToPasswordDividerLine.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailToPasswordDividerLine.widthAnchor.constraintEqualToAnchor(inputsViewContainerView.widthAnchor).active = true
        emailToPasswordDividerLine.heightAnchor.constraintEqualToConstant(1).active = true
        


        
        
    }
    
    func setupLoginButton() {
        
        // Autolayout inputsViewContainerView
        // x, y, width, height constraints
        
        loginButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginButton.topAnchor.constraintEqualToAnchor(inputsViewContainerView.bottomAnchor, constant: 10).active = true
        loginButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -25).active = true
        loginButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    
    
    
    
}
