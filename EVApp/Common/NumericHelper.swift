//
//  StringHelper.swift
//  EVApp
//
//  Created by VM on 22/06/24.
//

import Foundation
extension Numeric{
    func rupeeString()-> String{
        return "₹\(self)"
    }
    
    
}
extension FloatingPoint{
    func precisedString(upTo digitCount: Int)->String{
        return String(format: "%.\(digitCount)f", self as! CVarArg)
    }
    
    func rupeeString(withPrecision: Int)-> String{
        return "₹" + String(format: "%.\(withPrecision)f", self as! CVarArg)
    }
}
