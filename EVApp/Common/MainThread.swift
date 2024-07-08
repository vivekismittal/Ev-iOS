//
//  MainThread.swift
//  EVApp
//
//  Created by VM on 27/06/24.
//

import Foundation
func MainAsyncThread(_ block: @escaping ()->()) {
    DispatchQueue.main.async{
        block()
    }
}
