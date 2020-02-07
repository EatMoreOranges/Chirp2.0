//
//  LoginViewController.swift
//  Twitter
//
//  Created by EatMoreOranges on 2/7/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func onLoginButton(_ sender: Any) {
        //do this every time we click the button
        let theURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: theURL, success: {
            //do this when the login is successful
            //perform segue aka the transition
            //withIdentifier: "loginToHome": "loginToHome" is the name of the transition we created
            self.performSegue(withIdentifier: "loginToHome", sender: self)
       
        }, failure: { (Error) in
            print("Could not login!! ")
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
