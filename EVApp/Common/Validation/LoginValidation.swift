//
//  LoginValidation.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 29/05/23.
//

import Foundation

struct LoginValidation {

    func Validate(loginRequest: LoginRequest) -> ValidationResult
    {
        if(loginRequest.userPhone!.isEmpty)
        {
            return ValidationResult(success: false, error: "User phone is empty")
        }

        if(loginRequest.userPassword!.isEmpty)
        {
            return ValidationResult(success: false, error: "User password is empty")
        }

        return ValidationResult(success: true, error: nil)
    }

}
