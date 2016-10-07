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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func resignKeyboardWithTap() {
        if self.nameTextField.isFirstResponder == true {
            self.nameTextField.resignFirstResponder()
            return
        }
        if self.emailTextField.isFirstResponder == true {
            self.emailTextField.resignFirstResponder()
            return
        }
        
        if self.passwordTextField.isFirstResponder == true {
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
        let alert = UIAlertController(title: "Incomplete", message: "Could not login/Register", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "Succesfully logged in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        

        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //handle login helper
    func handleLogin() {
        self.resignFirstResponder()
        
//       guard let
//            email = emailTextField.text,
//            password = passwordTextField.text where !email.isEmpty && !password.isEmpty else {
//                failureAlert()
//                print("Login form not complete")
//                return
//        }
//        
        guard let email = emailTextField.text, let password = passwordTextField.text , !email.isEmpty && !password.isEmpty else {
            failureAlert()
            print("form incomplete")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
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
            let email = emailTextField.text,
            let password = passwordTextField.text , !name.isEmpty && !email.isEmpty && !password.isEmpty else {
                failureAlert()
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error) in
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
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        //view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.gray
        button.setTitle("Register", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //add action to register/login (FIREBASE)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
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
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    let nameToEmailDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let emailToPasswordDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Segmented Controller
    
    lazy var loginRegisterSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.layer.cornerRadius = 5
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    // MARK: Segmented Control action methods
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegementedControl.titleForSegment(at: loginRegisterSegementedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        inputsViewContainerHeightConstraint?.constant = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightConstraint?.isActive = false
        let nameTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 0 : 1/3
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: nameTextFieldMultiplier)
        nameTextFieldHeightConstraint?.isActive = true
        nameTextField.isHidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        
        emailTextFieldHeightConstraint?.isActive = false
        let emailTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: emailTextFieldMultiplier)
        emailTextFieldHeightConstraint?.isActive = true
        
        passwordTextFieldHeightConstraint?.isActive = false
        let passwordTextFieldMultiplier: CGFloat = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: passwordTextFieldMultiplier)
        passwordTextFieldHeightConstraint?.isActive = true
        
        
        
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
        
        inputsViewContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsViewContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsViewContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        inputsViewContainerHeightConstraint = inputsViewContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsViewContainerHeightConstraint?.isActive = true
        
        // Add nameTextField to container & autolayout
        inputsViewContainerView.addSubview(nameTextField)
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsViewContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsViewContainerView.topAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsViewContainerView.rightAnchor, constant: -12).isActive = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        // Add emailTextField to container & autolayout
        inputsViewContainerView.addSubview(emailTextField)
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsViewContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsViewContainerView.rightAnchor, constant: -12).isActive = true
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        
        // Add passwordTextField to container & autolayout
        inputsViewContainerView.addSubview(passwordTextField)
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsViewContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsViewContainerView.rightAnchor, constant: -12).isActive = true
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsViewContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
        
        
        // Add nameToEmailDividerLine to container & autolayout
        inputsViewContainerView.addSubview(nameToEmailDividerLine)
        // x, y, width, height constraints
        nameToEmailDividerLine.leftAnchor.constraint(equalTo: inputsViewContainerView.leftAnchor).isActive = true
        nameToEmailDividerLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameToEmailDividerLine.widthAnchor.constraint(equalTo: inputsViewContainerView.widthAnchor).isActive = true
        nameToEmailDividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Add emailToPasswordDividerLine to container & autolayout
        inputsViewContainerView.addSubview(emailToPasswordDividerLine)
        // x, y, width, height constraints
        emailToPasswordDividerLine.leftAnchor.constraint(equalTo: inputsViewContainerView.leftAnchor).isActive = true
        emailToPasswordDividerLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailToPasswordDividerLine.widthAnchor.constraint(equalTo: inputsViewContainerView.widthAnchor).isActive = true
        emailToPasswordDividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        


        
        
    }
    // autolayout setup for login & register button
    func setupLoginButton() {
        
        // Autolayout inputsViewContainerView
        // x, y, width, height constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsViewContainerView.bottomAnchor, constant: 10).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    // autolayout setup for segemnted control view
    func setupLoginRegisterSegmentedControl() {
        // need x, y, width, height constraints
        
        loginRegisterSegementedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegementedControl.bottomAnchor.constraint(equalTo: inputsViewContainerView.topAnchor, constant: -10).isActive = true
        loginRegisterSegementedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        loginRegisterSegementedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    

    
}
