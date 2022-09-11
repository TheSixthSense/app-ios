//
//  ChallengeDetailPayload.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public struct ChallengeDetailPayload {
    let id: Int
    let imageURL: String
    let date: Date
    let comment: String
    
    public init(id: Int, imageURL: String, date: Date, comment: String) {
        self.id = id
        self.imageURL = imageURL
        self.date = date
        self.comment = comment
    }
}
