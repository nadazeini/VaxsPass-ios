//
//  ChatbotViewController.swift
//  VaxsPass
//
//  Created by Nikita Petrenko on 2/14/21.
//

import UIKit
import AVFoundation
import Alamofire

class ChatbotViewController: UIViewController {
    
    var query: [String: AnyObject] = ["query": ""]

    @IBOutlet weak var responseField: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func askButton(_ sender: Any) {
        query["query"] = textField.text
        Alamofire.request("https://glacial-inlet-64915.herokuapp.com/openai", method: .post, parameters: query).responseJSON { response in
            print(response.request)   // original url request
            print(response.response) // http url response
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
