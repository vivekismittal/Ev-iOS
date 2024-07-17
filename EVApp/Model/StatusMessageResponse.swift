//
//  StatusMessageProtocol.swift
//  EVApp
//
//  Created by VM on 16/07/24.
//

import Foundation

struct StatusMessageResponse: Decodable{
    let status: String?
    let message: String?
}
