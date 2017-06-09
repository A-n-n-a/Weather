//
//  ViewController.swift
//  Weather
//
//  Created by Anna on 09.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginBtn: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        //loginBtn = LoginButton(readPermissions: .publicProfile)
        loginBtn.center = view.center
        
        view.addSubview(loginBtn)
        //loginButton.delegate = self as? LoginButtonDelegate
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print(result)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out")
    }


}

