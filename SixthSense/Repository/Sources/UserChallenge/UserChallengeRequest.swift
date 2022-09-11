//
//  UserChallengeRequest.swift
//  Repository
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import Moya

public struct ChallengeVerifyRequest {
    var id: Int
    var image: UIImage?
    var text: String?
    
    public init(id: Int, image: UIImage?, text: String?) {
        self.id = id
        self.image = image
        self.text = text
    }
}

extension ChallengeVerifyRequest {
    var asMultipart: [MultipartFormData] {
        return [
            .init(provider: .data(self.image!.jpegData(compressionQuality: 0.5)!), name: "images", fileName: "\(self.id).jpeg", mimeType: "image/jpeg"),
            .init(provider: .data(String(self.id).data(using: .utf8)!), name: "userChallengeId"),
            .init(provider: .data(String(self.text ?? " ").data(using: .utf8)!), name: "memo")
        ]
    }
}
