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
    
    var query: Parameters = ["query": ""]

    @IBOutlet weak var responseField: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func askButton(_ sender: Any) {
        if let safeText = textField.text{
            query["query"] = safeText
            AF.request("https://glacial-inlet-64915.herokuapp.com/openai",method: .post,parameters: query,encoding: JSONEncoding.default, headers: .none).responseData(completionHandler: { (response) in
                if let safeData = response.data {
                    let decodedData = try? JSONDecoder().decode(Chat.self, from: safeData)
                    self.responseField.text = decodedData?.response
                    
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
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(String.self, forKey: .response)
    }
}
