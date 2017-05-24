//
//  FindSoul.swift
//  Soulmate
//
//  Created by Pedro Neves Alvarez on 5/22/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FindSoul: UIViewController {

    @IBOutlet weak var SoulmateImage: UIImageView!
    
    var displayUserId = ""
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrPassed = ""
            
            if label.center.x < 100 {
                
                acceptedOrPassed = "passed"
                print("Not chosen")
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrPassed = "accepted"
                print("Chosen")
                
            }
            
            if acceptedOrPassed != "" && displayUserId != ""{
                
                PFUser.current()?.addUniqueObjects(from: [displayUserId], forKey: acceptedOrPassed )
                PFUser.current()?.signUpInBackground(block: { (success,error) in
                    
                    self.updateImage()
                    
                })
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
            
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }

    }
    @IBAction func LogOut(_ sender: Any) {
        
        performSegue(withIdentifier: "LogOutSegue", sender: self)
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    func updateImage(){
        
        /*let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: PFUser.current()?["interestedInFemales"]! as Any)
        query?.whereKey("interestedInFemales", equalTo: PFUser.current()?["isFemale"]! as Any)
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects,error) in
            
            if let users = objects{
                
                for object in users{
                    
                    if let user = object as? PFUser{
                        
                        self.displayUserId = user.objectId!
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: {(data,error) in
                            
                            if let imagedata = data{
                                
                                self.SoulmateImage.image = UIImage(data: imagedata)
                            }
                            
                        })
                    }
                }
                
            }
            
        })*/
        
        let query = PFUser.query()
        
        print(PFUser.current()!)
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["interestedInFemales"])!)
        
        query?.whereKey("interestedInFemales", equalTo: (PFUser.current()?["isFemale"])!)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.current()?["passed"] {
            
            ignoredUsers += rejectedUsers as! Array
            
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                
                for object in users {
                    
                    
                    if let user = object as? PFUser {
                        
                        self.displayUserId = user.objectId!
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if error != nil {
                                
                                print(error!)
                                
                            }
                            
                            if let imageData = data {
                                
                                self.SoulmateImage.image = UIImage(data: imageData)
                                
                            }
                            
                            
                        })
                        
                    }
                    
                }
                
                
            }
            
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        SoulmateImage.isUserInteractionEnabled = true
        
        SoulmateImage.addGestureRecognizer(gesture)
        
        updateImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LogOutSegue"{
            
            PFUser.logOut()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
