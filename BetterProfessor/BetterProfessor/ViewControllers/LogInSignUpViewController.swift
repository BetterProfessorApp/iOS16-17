//
//  LogInSignUpViewController.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class LogInSignUpViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet var logInTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var departmentTextField: UITextField!
    @IBOutlet var logInSignUpButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateViews()
        updateTap()
    }
    
     @IBAction func unwindLoginSegue(segue: UIStoryboardSegue) { }
    
    private func updateViews() {
        switch logInTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            confirmPasswordTextField.isHidden = false
            emailTextField.isHidden = false
            departmentTextField.isHidden = false
            
            logInSignUpButton.setTitle("Sign Up", for: .normal)
        default:
            confirmPasswordTextField.isHidden = true
            emailTextField.isHidden = true
            departmentTextField.isHidden = true

            logInSignUpButton.setTitle("Log In", for: .normal)
        }
    }

    @IBAction func didSwitchLogInType(_ sender: Any) {
        self.updateViews()
    }

    @IBAction func logInSignUp(_ sender: Any) {

        switch logInTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            self.signUp()
        default:
            self.logIn()
        }
    }
    
    func updateTap() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
           view.addGestureRecognizer(tapGesture)
       }
       
       @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
           print("tap")
           
           view.endEditing(true)
           
           switch(tapGesture.state) {
               
           case .ended:
               print("tapped again")
           default:
               print("Handled other states: \(tapGesture.state)")
           }
       }

    private func signUp() {
        activityIndicator.startAnimating()

        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            password == confirmPassword,
            !password.isEmpty,
            let department = departmentTextField.text,
            !department.isEmpty else {
                self.showAlertMessage(title: "ERROR", message: "Failed to sign up", actiontitle: "OK")
                self.activityIndicator.stopAnimating()
                return
        }

        BackendController.shared.signUp(username: username, password: password, department: department) { result, _, error in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "ERROR", message: "Failed to sign up", actiontitle: "OK")
                    NSLog("⚠️ ERROR: \(error)")
                    return
                }
            }

            if result {
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "Success", message: "You have been successfully signed up", actiontitle: "OK")
                    self.logIn()
                }
            }
        }
    }

    private func logIn() {
        activityIndicator.startAnimating()

        guard let username = usernameTextField.text,
        !username.isEmpty,
        let password = passwordTextField.text,
        !password.isEmpty else {
            self.activityIndicator.stopAnimating()
            return
        }

        BackendController.shared.signIn(username: username, password: password) { result in
            defer {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }

            DispatchQueue.main.async {
                if result {
                    self.performSegue(withIdentifier: "StudentViewSegue", sender: self)
                } else {
                    self.showAlertMessage(title: "ERROR", message: "Failed to log in", actiontitle: "OK")
                    return
                }
            }
        }
    }

    func showAlertMessage(title: String, message: String, actiontitle: String) {
        let endAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let endAction = UIAlertAction(title: actiontitle, style: .default) { (action: UIAlertAction ) in
        }
        endAlert.addAction(endAction)
        present(endAlert, animated: true, completion: nil)
    }
}
