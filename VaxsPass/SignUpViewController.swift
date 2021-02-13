//
//  SignUpViewController.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 13/02/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        if(confirmPassword.text != password.text){
            let alert  = UIAlertController(title: "Error", message: "Password and Confirm Password should be same", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if let finalEmail = email.text, let finalPassword = password.text {
            Auth.auth().createUser(withEmail: finalEmail, password: finalPassword) { authResult,error   in
                if let user = authResult?.user {
                    print(user)
                } else {
                    print("Error")
                }
            }
            
        }
    }
}
