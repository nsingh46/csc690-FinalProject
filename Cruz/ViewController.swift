//
//  ViewController.swift
//  Cruz
//
//  Created by charan singh on 12/11/19.
//  Copyright © 2019 Navneet Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passText: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    var signUpScreen = true
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func SignUpActButton(_ sender: Any)
    {
        if emailText.text == "" || passText.text == ""
        {
            errorAlert(title: "MISSING INFO ", message: " Please fill in the missing information")
        }
        else
            {
                if let em = emailText.text
                {
                    if let pass = passText.text
                    {
                  
                        if signUpScreen
                       {
                        
                        createuser(email: em, password: pass)
                        
                        }else
                            {
                             loginSignIn(email: em, password: pass)
                        }
                    }
                }
            }
    }
    
    func createuser(email:String, password:String)
        {
              Auth.auth().createUser(withEmail:email, password:password, completion:
              {(user, error)in
                  if error != nil
                      {
                       self.errorAlert(title: "ERROR", message: error!.localizedDescription)
                      }
                  else
                      {
                          print("Account has been created")
                          self.performSegue(withIdentifier: "customerPathway", sender: nil)
                      }
              })
        }
    
    func loginSignIn(email:String, password:String)
        {
                Auth.auth().signIn(withEmail: email, password: password, completion:
                {(user, error) in
                
                   if error != nil
                    {
                       self.errorAlert(title: "ERROR", message: error!.localizedDescription)
                    }
                    else
                    {
                        print("Account login was successful")
                        self.performSegue(withIdentifier: "customerPathway", sender: nil)
                    }
                })
        }
    
    func errorAlert(title:String, message:String)
    {
        let errorController = UIAlertController(title:title, message:message, preferredStyle: .alert)
        errorController.addAction(UIAlertAction(title: "okay", style: .default, handler: nil)  )
        self.present(errorController, animated: true, completion: nil)
    }
    
    
    @IBAction func logInActButton(_ sender: Any)
    {
        if signUpScreen
            {
            signUpScreen = false
            signUpButton.setTitle("Login", for: .normal)
            logInButton.setTitle("Direct to Sign Up", for: .normal)
         //   driverText.isHidden = true
            
           
            }
        else {
             signUpScreen = true
            signUpButton.setTitle("Sign Up", for: .normal)
            logInButton.setTitle("Go to Login", for: .normal)
         //   driverText.isHidden = false
           
            
            }
       
        
        
    }
}

