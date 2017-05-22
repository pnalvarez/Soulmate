//
//  ProfileViewController.swift
//  Soulmate
//
//  Created by Pedro Neves Alvarez on 5/22/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate{

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestedInSwitch: UISwitch!
    @IBOutlet weak var SituationLabel: UILabel!
    
    @IBAction func UpdateImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            ProfileImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UpdateProfile(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["interestedInFemales"] = interestedInSwitch.isOn
      
        let imagedata = UIImagePNGRepresentation(ProfileImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "Profile.png", data: imagedata!)
        
        PFUser.current()?.saveInBackground(block: { (success,error) in
            
            if error != nil{
                
                var errorMessage = "Failed to save image"
                let auxError = error! as NSError
                
                if let parseError = auxError.userInfo["error"] as? String{
                    
                    errorMessage = parseError
                }
            
                self.SituationLabel.textColor = UIColor.black
                self.SituationLabel.text = errorMessage
            }
            else{
                print("Updated")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileImage.image = UIImage(named: "05-512.png")
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool{
            
            genderSwitch.setOn(isFemale, animated: false)
        }

        if let interestedInWoman = PFUser.current()?["interestedInFemales"] as? Bool{
            
            interestedInSwitch.setOn(interestedInWoman, animated: false)
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile{
            
            photo.getDataInBackground(block: { (data,error) in
                
                if let imagedata = data{
                    
                    if let downloadedImage = UIImage(data: imagedata){
                        
                        self.ProfileImage.image = downloadedImage
                    }
                }
                
                
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
