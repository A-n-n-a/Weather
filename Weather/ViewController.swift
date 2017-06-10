//
//  ViewController.swift
//  Weather
//
//  Created by Anna on 09.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        
        self.performSegue(withIdentifier: "redirectAfterLogin", sender: self)
    }


    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print(result)
        //print("login complete")
        self.performSegue(withIdentifier: "redirectAfterLogin", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out")
    }


}

