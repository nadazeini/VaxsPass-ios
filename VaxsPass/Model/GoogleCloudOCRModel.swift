//
//  GoogleCloudOCRModel.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//
import Foundation
import UIKit

struct Annotation: Codable {
    let text: String
    let pfizer: Bool
    let moderna: Bool
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case text
        case pfizer
        case moderna
        case count
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text).lowercased()
        pfizer = text.contains("pfizer")
        moderna = text.contains("moderna")
        var vacine = ""
        if pfizer {
            vacine = "pfizer"
        }else if moderna {
            vacine = "moderna"
        }
        
        count = text.countInstances(of: vacine)
    }
}

struct OCRResult: Codable {
    let annotations: Annotation
    enum CodingKeys: String, CodingKey {
        case annotations = "fullTextAnnotation"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        annotations = try container.decode(Annotation.self, forKey: .annotations)
    }
}

struct GoogleCloudOCRResponse: Codable {
    let responses: [OCRResult]
    enum CodingKeys: String, CodingKey {
        case responses = "responses"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responses = try container.decode([OCRResult].self, forKey: .responses)
    }
}
