//
//  ApiManageer.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation

final class NewNetworkManager {

    static let shared = NewNetworkManager()
    
    func request<T: Decodable>(
        endPointType: ServerEndPointType, modelType: T.Type,
        completion: @escaping ResultHandler<T>
    ) {
        guard let urlRequest = endPointType.getUrlRequest() else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }

        // Network Request - URL TO DATA
        requestDataAPI(url: urlRequest) { result in
            switch result {
            case .success(let data):
                // Json parsing - Decoder - DATA TO MODEL
                self.parseResonseDecode(data: data,modelType: modelType) { res in
                        switch res {
                        case .success(let decodedObj):
                            completion(.success(decodedObj)) // Final
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            completionHandler(.success(data))
        }
        session.resume()
    }
    
   private func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ){
        do{
            let userResponse = try JSONDecoder().decode(T.self, from: data)
            completionHandler(.success(userResponse))
            print(userResponse)
        } catch {
            completionHandler(.failure(.decoding(error)))
        }
    }

}

typealias ResultHandler<T> = (Result<T, DataError>) -> Void
