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
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var GenerateQRButton: UIButton!
    var qrcodeImage: CIImage!
    var create_user_params : [String:Any] = [
        "oauth": "",
        "name": "test123",
        "date" : "01/01/2021",
        "vaccine_type" : "None",
        "taken": 1,
        "completed": false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        image.allowsEditing = false
        self.create_user_params.updateValue(self.userID ?? "", forKey: "oauth")
    }
    let create_user_url = "https://glacial-inlet-64915.herokuapp.com/create-user"
    @IBAction func GenerateQRCode(_ sender: Any) {
        self.postRequest(url:create_user_url, parameters: self.create_user_params , completion: {response in
                    print("done calling")
            if let json = response as? Dictionary<String,AnyObject> {
//                print(json["status"] ?? "no response")
//                print(json["encode"] ?? "no response")
//                print(json["txid"] ?? "no response")
                if(json["status"] as! String  == "Success"){
                    print("equal \(json["status"].debugDescription)")
                    //generate qr code here on
                    let passUrl = "https://glacial-inlet-64915.herokuapp.com/index.html?oauth=\(self.create_user_params["oauth"] ?? "")"
                    let stringData = passUrl.data(using: .utf8)
                    if self.qrcodeImage == nil {
                        let filter = CIFilter(name: "CIQRCodeGenerator")
                        filter?.setValue(stringData, forKey: "inputMessage")
                        filter?.setValue("Q", forKey: "inputCorrectionLevel")
                        self.qrcodeImage = filter?.outputImage
                        self.imgQRCode.image = UIImage(ciImage: self.qrcodeImage)
                    }
                }
            }
        })
    }
    func postRequest(url: String,parameters:[String:Any],completion : @escaping (Any) -> Void){
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if(response.error == nil){
                    completion(response.value)
                } else {
                    print("failed")
                    print(response)
                    completion(response.value)
                }
            }
    }
    let image = UIImagePickerController()
    let headers: HTTPHeaders = [
        "Authorization": "Bearer AIzaSyBZZOFM9otkX6J0NsDtDoNyNybY3HG7xeE",
        "Content-Type": "application/json; charset=utf-8"
    ]

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage , let base64Image = userImage.jpegData(compressionQuality: 1)?.base64EncodedString(){
            
            let json = """
{
            "requests": [
              {
                "image": {
                  "content": \(base64Image)
                },
                "features": [
                  {
                    "type": "DOCUMENT_TEXT_DETECTION"
                  }
                ]
              }
            ]
          }
"""
            let parameters = json.data(using: .utf8)!
            let result = AF.request("https://vision.googleapis.com/v1/images:annotate", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            print(result.data as Any)
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
}
