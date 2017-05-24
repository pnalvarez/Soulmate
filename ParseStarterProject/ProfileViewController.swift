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
                self.performSegue(withIdentifier: "ShowFindSoul", sender: self)
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
        
        /*let urlArray = ["https://img.clipartfest.com/6c6b4b848eedb01bf2600d66891cff73_funny-female-cartoon-character-names-kids-pinterest-sunshine-female-cartoon-characters-names_320-240.jpeg","http://www.thezerosbeforetheone.com/wordpress/wp-content/uploads/2011/07/smurfette-300x225.gif","https://s-media-cache-ak0.pinimg.com/236x/39/17/33/3917338162bb9eb2b63a23545e09f409.jpg","http://img3.wikia.nocookie.net/__cb20090216134906/fantendo/images/a/ab/Toon_Zelda.jpg","http://vignette1.wikia.nocookie.net/zelda/images/3/35/Toon_Zelda_%28Hyrule_Warriors%29.png/revision/latest?cb=20160902021811","http://main-im-char-1.gamewise.co/Hilda-Zelda-231446-full.png","https://s-media-cache-ak0.pinimg.com/736x/24/b6/1d/24b61d8d873bb34abe3cd6d8358313d5.jpg"]
        
        var counter = 0
        
        for urlString in urlArray{
            
            counter+=1
            
            let url = URL(string: urlString)!
            
            do{
                
            let data = try Data(contentsOf: url)
            let imageFile = PFFile(name: "photo\(counter).png",data: data)
            let user = PFUser()
            user["photo"] = imageFile
            user.username = "Girl \(counter)"
            user.password = "password"
            user["isFemale"] = true
            user["interesteInFemales"] = false
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success,error) in
                    
                    if success{
                        
                        print("New User 4U")
                    }
                    
                    
                })
            }
            catch{
                print("could not get data")
            }
        }*/
        // Do any additional setup after loading the view.
        
        let urlArray = ["http://cdn.madamenoire.com/wp-content/uploads/2013/08/penny-proud.jpg", "http://static.makers.com/styles/mobile_gallery/s3/betty-boop-cartoon-576km071213_0.jpg?itok=9qNg6GUd", "http://file1.answcdn.com/answ-cld/image/upload/f_jpg,w_672,c_fill,g_faces:center,q_70/v1/tk/view/cew/e8eccfc7/e367e6b52c18acd08104627205bbaa4ae16ee2fd.jpeg", "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=1760886", "http://vignette3.wikia.nocookie.net/simpsons/images/0/0b/Marge_Simpson.png/revision/20140826010629", "http://static6.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG", "https://itfinspiringwomen.files.wordpress.com/2014/03/scooby-doo-tv-09.jpg", "https://s-media-cache-ak0.pinimg.com/236x/9c/5e/86/9c5e86be6bf91c9dea7bac0ab473baa4.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
                
                let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["interestedFemales"] = false
                
                user["isFemale"] = true
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                        
                        print("user signed up")
                        
                    }
                    
                })
                
            } catch {
                
                print("Could not get data")
                
            }
            
        }

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
