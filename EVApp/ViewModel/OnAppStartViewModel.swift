//
//  OnAppStartViewModel.swift
//  EVApp
//
//  Created by VM on 05/06/24.
//

import Foundation

class OnAppStartViewModel{
    static let shared = OnAppStartViewModel()
    
   private init() {}
    
    func versionAPIRequest(completionHandler: @escaping ResultHandler<Version>) {
        NewNetworkManager.shared.request(
            endPointType: .getAppVersion, modelType: Version.self) { response in
                switch response {
                case .success(let version):
                    completionHandler(.success(version))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
