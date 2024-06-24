//
//  WalletRepo.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class WalletRepo{
    
    func getWalletBalance(completionHandler: @escaping ResultHandler<Float>) {
        let parameters = ["userPk": UserAppStorage.userPk]
        NewNetworkManager.shared.request(endPointType: .getWalletAmount(parameters), modelType: MyWallet.self) { response in
            switch response {
            case .success(let myWallet):
                if let walletBalance = myWallet.amount{
                    completionHandler(.success(walletBalance))
                } else {
                    completionHandler(.failure(.invalidData))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
