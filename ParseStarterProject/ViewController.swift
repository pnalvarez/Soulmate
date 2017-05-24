/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    var sigupMode = true
    var errorMessage: String = ""
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == ""{
            
            createAlert(title: "Field missing", message: "Enter a new username or password")
            
        }
        
        else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 50, height: 50 ))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if sigupMode{
                
                //SIGN UP
                
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
            
                let acl = PFACL()
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: {(success,error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                        
                        var displayErrorMessage = "Please try again"
                        let parseError = error as NSError?
                        self.errorMessage = parseError?.userInfo["error"] as! String
                        displayErrorMessage = self.errorMessage
                        
                        self.createAlert(title: "Sign up error", message: displayErrorMessage)
                    }
                    
                    else{
                        
                       self.SituationLabel.textColor = UIColor.red
                       self.SituationLabel.backgroundColor = UIColor.blue
                       self.SituationLabel.text = "Perfect signing up"
                        
                       self.performSegue(withIdentifier: "goToprofile", sender: self)
                    }
                    
                    
                })
                
            }
            
            else{
                //Log in Mode
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: {(user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                        
                        var displayErrorMessage = "Please try again"
                        let parseError = error as NSError?
                        self.errorMessage = parseError?.userInfo["error"] as! String
                        displayErrorMessage = self.errorMessage
                        
                        self.createAlert(title: "Log in error", message: displayErrorMessage)
                        
                    }
                    else{
                        
                        self.SituationLabel.textColor = UIColor.red
                        self.SituationLabel.backgroundColor = UIColor.green
                        self.SituationLabel.text = "Perfect Login"
                        
                        self.redirectUser()
                        //self.performSegue(withIdentifier: "goToProfile", sender: self)
                    }
                    
                    
                })
                
                
            }
            
        }
        
        
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    @IBOutlet weak var changeSignupModeButton: UIButton!
    
    @IBOutlet weak var SituationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if sigupMode{
            
            signupOrLoginButton.setTitle("Log in", for: [])
            changeSignupModeButton.setTitle("Sign up", for: [])
            messageLabel.text = "Are you new?"
            sigupMode = false
        }
        
        else{
            
            signupOrLoginButton.setTitle("Sign up", for: [])
            changeSignupModeButton.setTitle("Log in", for: [])
            messageLabel.text = "Aren't you new here?"
            sigupMode = true
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       //redirectUser()
    }

    func redirectUser(){
        
        if PFUser.current() != nil{
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["interestedInFemales"] != nil && PFUser.current()?["photo"] != nil {
                
                performSegue(withIdentifier: "ShowFindSouls", sender: self)
            }else{
                performSegue(withIdentifier: "goToProfile", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordTextField.isSecureTextEntry = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
