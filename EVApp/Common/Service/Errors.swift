//
//  Errors.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}
