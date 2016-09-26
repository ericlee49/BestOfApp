//
//  LoginController.swift
//  BestOf
//
//  Created by Eric Lee on 2016-09-13.
//  Copyright © 2016 Erics App House. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 168/255, green: 3/255, blue: 3/255, alpha: 1)
        self.navigationItem.title = "Login/Register"
        
        view.addSubview(inputsViewContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegementedControl)
        setupContainerView()
        setupLoginButton()
        setupLoginRegisterSegmentedControl()
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self


        
        // Resign keyboard when view is tapped outside keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyboardWithTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: UITextField Delegate Protocols
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField === self.nameTextField {
            self.emailTextField.becomeFirstResponder()
            return true
        }
        if textField === self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
            return true
        }
        if textField === self.passwordTextField {
            handleLoginRegister()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func resignKeyboardWithTap() {
        if self.nameTextField.isFirstResponder() == true {
            self.nameTextField.resignFirstResponder()
            return
        }
        if self.emailTextField.isFirstResponder() == true {
            self.emailTextField.resignFirstResponder()
            return
        }
        
        if self.passwordTextField.isFirstResponder() == true {
            self.passwordTextField.resignFirstResponder()
            return
        }
    }
    
    
    // MARK: Firebase helper methods:
    

    //handle login / register
    
    func handleLoginRegister() {
        if loginRegisterSegementedControl.selectedSegmentIndex == 0 {
            // LOGIN
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    
    func failureAlert() {
        let alert = UIAlertController(title: "Incomplete", message: "Could not login/Register", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "Succesfully logged in", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alert: UIAlertAction) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        

        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    //handle login helper
    func handleLogin() {
        self.resignFirstResponder()
        
//        guard let
//            email = emailTextField.text,
//            password = passwordTextField.text where !email.isEmpty && !password.isEmpty else {
//                failureAlert()
//                print("Login form not complete")
//                return
//        }
//        
        guard let email = emailTextField.text, password = passwordTextField.text where !email.isEmpty && !password.isEmpty else {
            failureAlert()
            print("form incomplete")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
           
            self.successAlert()
            
            
        })
        
    }
    
    //handle register helper
    func handleRegister() {
        
        self.resignFirstResponder()
        
        guard let
            name = nameTextField.text,
            email = emailTextField.text,
            password = passwordTextField.text where !name.isEmpty && !email.isEmpty && !password.isEmpty else {
                failureAlert()
                return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user:FIRUser?, error) in
            if error != nil {
                print(error)
                print("failed to create user in Firebase *******")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email":email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                self.successAlert()
                
                print("Successfully saved user to Firebase db")
            })
        })
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
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(red: 195/255, green: 3/255, blue: 3/255, alpha: 1)
        button.setTitle("Register", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //add action to register/login (FIREBASE)
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        
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
        textField.autocapitalizationType = UITextAutocapitalizationType.None
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
    
    
    // Segmented Controller
    
    lazy var loginRegisterSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.layer.cornerRadius = 5
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        return sc
    }()
    
    // MARK: Segmented Control action methods
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegementedControl.titleForSegmentAtIndex(loginRegisterSegementedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        inputsViewContainerHeightConstraint?.constant = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightConstraint?.active = false
        let nameTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 0 : 1/3
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: nameTextFieldMultiplier)
        nameTextFieldHeightConstraint?.active = true
        
        emailTextFieldHeightConstraint?.active = false
        let emailTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: emailTextFieldMultiplier)
        emailTextFieldHeightConstraint?.active = true
        
        passwordTextFieldHeightConstraint?.active = false
        let passwordTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: passwordTextFieldMultiplier)
        passwordTextFieldHeightConstraint?.active = true
        
        
        
        // switch
    }
    
    
    
    
    // MARK: Views setup & autolayouts

    var inputsViewContainerHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var passwordTextFieldHeightConstraint: NSLayoutConstraint?

    
    func setupContainerView() {
        
        // Autolayout inputsViewContainerView
        // x, y, width, height constraints
        
        inputsViewContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsViewContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsViewContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -25).active = true
        inputsViewContainerHeightConstraint = inputsViewContainerView.heightAnchor.constraintEqualToConstant(150)
        inputsViewContainerHeightConstraint?.active = true
        
        // Add nameTextField to container & autolayout
        inputsViewContainerView.addSubview(nameTextField)
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsViewContainerView.topAnchor).active = true
        nameTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightConstraint?.active = true
        
        // Add emailTextField to container & autolayout
        inputsViewContainerView.addSubview(emailTextField)
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightConstraint?.active = true
        
        
        // Add passwordTextField to container & autolayout
        inputsViewContainerView.addSubview(passwordTextField)
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsViewContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.rightAnchor.constraintEqualToAnchor(inputsViewContainerView.rightAnchor, constant: -12).active = true
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsViewContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightConstraint?.active = true
        
        
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
    // autolayout setup for login & register button
    func setupLoginButton() {
        
        // Autolayout inputsViewContainerView
        // x, y, width, height constraints
        
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsViewContainerView.bottomAnchor, constant: 10).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -25).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    
    // autolayout setup for segemnted control view
    func setupLoginRegisterSegmentedControl() {
        // need x, y, width, height constraints
        
        loginRegisterSegementedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegementedControl.bottomAnchor.constraintEqualToAnchor(inputsViewContainerView.topAnchor, constant: -10).active = true
        loginRegisterSegementedControl.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -25).active = true
        loginRegisterSegementedControl.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    

    
}
