//
//  CreateAccountVC.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/18/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
 //   @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Variables - keep track of the avatar name and color
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5]"
    var bgColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
   
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        
        // pick randomly generated color
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
       
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor = self.bgColor
        }
        
        
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else {
            self.spinner.stopAnimating()
            return
        }
        guard let pass = passTxt.text, passTxt.text != "" else {
            self.spinner.stopAnimating()
            return
        }
//        guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
        
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("registered user!")
                print("\(success.description)")
                
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    
                    if success {
                        print("Logged in user!", AuthService.instance.authToken)
                        AuthService.instance.createUser(name: "", email: email, completion: { (success) in
                            
                            if success {
                                
                                // Update the UI, pull down the channels, update the chatVC
                                
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                                // send out notification of what we've done with the user
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    func setupView() {
    spinner.isHidden = true
        
        // change color of placeholder text
  //      usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap() {
        view.endEditing(true)
    }
    
    
    
}

