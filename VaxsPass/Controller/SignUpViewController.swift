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
                var message: String = ""
                if (authResult?.user) != nil {
                    message = "User was sucessfully created."
                    //add username to firebase
                    let userID = Auth.auth().currentUser?.uid
                    FirebaseReferences.usersRef.child(userID!).setValue(["username": self.fullName.text])
                } else {
                    message = "There was an error."
                }
//                FirebaseReferences.usersRef.observeSingleEvent(of: .value) { (snapshot) in
//                    if snapshot.hasChild(userID!){
//                        print("user is in database")
//                    }
//                    else{
//                        print("adding user to database")
//                        let newUser = FirebaseReferences.usersRef.child(userID!)
////                        newUser.setValue(hasJoined)
//                    }}
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.performSegue(withIdentifier: "signIn", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
