//
//  ReviewRatingsModel.swift
//  EVApp
//
//  Created by VM on 19/07/24.
//

import Foundation
struct ReviewRatingsModel: Decodable{
    let status: Bool?
    let rating: Float?
    let comment: [Comment]?
}
