//
//  Comment.swift
//  EVApp
//
//  Created by VM on 18/07/24.
//

import Foundation

struct Comment: Decodable{
    let firstName: String?
    let rating: Float?
    let comment: String?
    
    var roundedRating: Int{
        Int(rating?.rounded() ?? 0)
    }
}
