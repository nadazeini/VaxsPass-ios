//
//  GoogleCloudOCR.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//

import Foundation
import Alamofire

class GoogleCloudOCR {
    private let apiKey = Secrets.GoogleKey.rawValue
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
                            "type": "TEXT_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
        ]
        AF.request(apiURL,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers).responseData { (response) in
            if let safeData = response.data {
                if let ocrResponse = try? JSONDecoder().decode(GoogleCloudOCRResponse.self, from: safeData){
                    completion(ocrResponse.responses[0])
                }
            }
            
        }
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

