//
//  ConnectorsViewModel.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation

final class ConnectosViewModel{
    var products: [StationList] = []
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func fetchConnectors() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: [StationList].self,
            type: ProductEndPoint.products) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let products):
                    print(products)
                    self.products = products
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
}
extension ConnectosViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
        //case newProductAdded(product: AddProduct)
    }

}
