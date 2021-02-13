//
//  VisionAPIRequest.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//

import Foundation

struct VisionAPIRequest {
    let requests: [Request]
    }

    // MARK: - Request
    struct Request: Codable {
        let image: Image
        let features: [Feature]
    }

    // MARK: - Feature
    struct Feature: Codable {
        let type: String
    }

    // MARK: - Image
    struct Image: Codable {
        let content: String
    }
