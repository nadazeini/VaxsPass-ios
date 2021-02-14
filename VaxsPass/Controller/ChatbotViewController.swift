//
//  ChatbotViewController.swift
//  VaxsPass
//
//  Created by Nikita Petrenko on 2/14/21.
//

import UIKit
import ApiAI
import AVFoundation

class ChatbotViewController: UIViewController {

    @IBOutlet weak var responseField: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func askButton(_ sender: Any) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.textField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
            
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        textField.text = ""
    }
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.responseField.text = text
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
