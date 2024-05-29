//
//  LoginRequest.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 29/05/23.
//

import Foundation

struct LoginRequest : Encodable
{
    var userPhone, userPassword: String?
}
