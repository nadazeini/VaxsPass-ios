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
    
    var query: Parameters = ["query": "what is coronavirus?"]

    @IBOutlet weak var responseField: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func askButton(_ sender: Any) {
        if let safeText = textField.text{
//            query["query"] = safeText
            AF.request("https://glacial-inlet-64915.herokuapp.com/openai",method: .post,parameters: query,headers: .none).responseData(completionHandler: { (response) in
                if let safeData = response.data {
                    print(try? JSONDecoder().decode(Chat.self, from: safeData))
//                    print(safeData as! JSON)
//                    print(response.request)
                    print(response.response)
                    }
                }
            )
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


struct Chat: Codable{
    let reponse: String
}
