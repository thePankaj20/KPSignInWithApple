//
//  ViewController.swift
//  KPSignInWithApple
//
//  Created by Pankaj Kaluram Kumhar on 11/02/20.
//  Copyright © 2020 Pankaj Kaluram Kumhar. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupLoginButton()
    }
    
    func setupLoginButton() {
        let btnAppleID = ASAuthorizationAppleIDButton(authorizationButtonType: ASAuthorizationAppleIDButton.ButtonType.continue, authorizationButtonStyle: .whiteOutline)
        btnAppleID.addTarget(self, action: #selector(self.handleBtnTap), for: .touchUpInside)
        btnAppleID.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnAppleID)
        
        NSLayoutConstraint.activate([
            btnAppleID.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnAppleID.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func handleBtnTap() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }


}

// MARK:- ASAuthorizationControllerDelegate

extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            let appleId = credentials.user

            let appleUserFirstName: String = credentials.fullName?.givenName ?? ""

            let appleUserLastName: String = credentials.fullName?.familyName ?? ""

            let appleUserEmail: String = credentials.email ?? ""
            
            let message: String = "Apple User ID: \(appleId), \n First Name: \(appleUserFirstName) \n Last Name: \(appleUserLastName), \n Email: \(appleUserEmail)"
            
            self.showAlert(withMessage: message)
        case let passwordCredentials as ASPasswordCredential:
            let appleUsername = passwordCredentials.user

            let applePassword: String = passwordCredentials.password
            
            let message: String  = "Apple User ID: \(appleUsername), \n  password: \(applePassword)"
            
            self.showAlert(withMessage: message)
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController error: \(error.localizedDescription)")
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController.init(title: "Apple ID Details", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- ASAuthorizationControllerPresentationContextProviding
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


