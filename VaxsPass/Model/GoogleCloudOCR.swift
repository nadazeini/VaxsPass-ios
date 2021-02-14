//
//  GoogleCloudOCR.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//

import Foundation
import Alamofire

class GoogleCloudOCR {
//    private let apiKey = "AIzaSyBZZOFM9otkX6J0NsDtDoNyNybY3HG7xeE"
    private let apiKey = "AIzaSyARNJeV0HUI1CcAVuKN6VQ__PwET2KZ6Rc"
    private var apiURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping (OCRResult?) -> Void) {
        guard let base64Image = base64EncodeImage(image) else {
            print("Error while base64 encoding image")
            completion(nil)
            return
        }
        callGoogleVisionAPI(with: base64Image, completion: completion)
    }
    
    private func callGoogleVisionAPI(with base64EncodedImage: String,completion: @escaping (OCRResult?) -> Void) {
        let parameters: Parameters = [
            "requests": [
                [
                    "image": [
                        "content": base64EncodedImage
                    ],
                    "features": [
                        [
                            "type": "DOCUMENT_TEXT_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
        ]
        AF.request(apiURL,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers).responseJSON { response in
                switch response.result {
                case .failure(let error):
                    print("Error")
                    print(error)
                    completion(nil)
                
                case .success(let sucess):
//                    completion(sucess as! OCRResult)
                    print(sucess)
                }
            }
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

