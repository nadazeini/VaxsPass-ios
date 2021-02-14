//
//  HomeViewController.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 13/02/21.
//

import UIKit
import Vision
import Alamofire
import Firebase

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let userID = Auth.auth().currentUser?.uid

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet var addDocumentsButton: UIButton!
    
    var qrcodeImage: CIImage!
    var name: String = ""
    let create_user_url = "https://glacial-inlet-64915.herokuapp.com/create-user"
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    var create_user_params : [String:Any] = [
        "oauth": "",
        "name": "test123", //need to update name to the one from firebase
        "date" : "01/01/2021",
        "vaccine_type" : "None",
        "taken": 1,
        "completed": false
    ]
    override func viewWillAppear(_ animated: Bool) {
//        FirebaseReferences.usersRef.child("\(userID!)/username").observeSingleEvent(of: .value) { (snapshot) in
//            let newLoc = FirebaseReferences.usersRef.child(child("\(userID!)/username"))
//        }
        let ref = FirebaseReferences.usersRef.child(userID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
             if let users = snapshot.value as? [String:Any] {
                  print(users["username"])
                self.username.text = users["username"] as? String
                self.name = users["username"] as? String ?? ""
                print("name \(self.name)")
             }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        image.allowsEditing = false
        self.create_user_params.updateValue(self.userID ?? "", forKey: "oauth")
    }
    
   
    func sendRequestAndGenerateQRCode(){
        
        self.postRequest(url:create_user_url, parameters: self.create_user_params , completion: {response in
                    print("done calling")
            if let json = response as? Dictionary<String,AnyObject> {
//                print(json["status"] ?? "no response")
//                print(json["encode"] ?? "no response")
//                print(json["txid"] ?? "no response")
                if(json["status"] as! String  == "Success"){
                    //generate qr code here on
                    let passUrl = "https://glacial-inlet-64915.herokuapp.com/index.html?oauth=\(self.create_user_params["oauth"] ?? "")"
                    let stringData = passUrl.data(using: .utf8)
                    if self.qrcodeImage == nil {
                        let filter = CIFilter(name: "CIQRCodeGenerator")
                        filter?.setValue(stringData, forKey: "inputMessage")
                        filter?.setValue("Q", forKey: "inputCorrectionLevel")
                        self.qrcodeImage = filter?.outputImage
                        self.imgQRCode.image = UIImage(ciImage: self.qrcodeImage)
                        
                        self.addDocumentsButton.isHidden = true
                        self.alert.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
    }
    func postRequest(url: String,parameters:[String:Any],completion : @escaping (Any) -> Void){
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if(response.error == nil){
                    print("loading")
                    completion(response.value)
                } else {
                    print("failed")
                    print(response)
                    self.alert.dismiss(animated: true, completion: nil)
                    self.showError()
                    completion(response.value)
                }
            }
    }
    let image = UIImagePickerController()
    let googleTextRec = GoogleCloudOCR()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            image.dismiss(animated: true, completion: nil)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating();

            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                self.googleTextRec.detect(from: userImage) { (results) in
                    let doses:Int = (results?.annotations.count)!
                    var completed = false
                    if(doses == 2){
                        completed = true
                    }
                    let vaccine_type = results?.annotations.moderna == true ? "Moderna" : "Pfizer"
                    let date = "soon"
                    self.create_user_params.updateValue(doses, forKey: "taken")
                    self.create_user_params.updateValue(vaccine_type , forKey: "vaccine_type")
                    self.create_user_params.updateValue(completed, forKey: "completed")
                    self.create_user_params.updateValue(date, forKey: "date")
//                    self.create_user_params.updateValue(self.name, forKey: "name")
                    print(self.create_user_params)
                    
                    self.sendRequestAndGenerateQRCode()
                }
            }
            
        }
        
    }
    
    @IBAction func addDocumentsPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose a Source", message: "From where would you like to add the document?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.image.sourceType = .camera
            self.present(self.image, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.image.sourceType = .photoLibrary
            self.present(self.image, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func showError(){
        let alert = UIAlertController(title: nil, message: "An Error Occured", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
