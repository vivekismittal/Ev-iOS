////
////  ServiceManager.swift
////  Smart World
////
////  Created by Ajitabh Upadhyay on 05/11/22.
////
//
//import Foundation
////import AVFoundation
//
//
//class ServiceManager {
//    static var shared = ServiceManager()
//    let session = URLSession.shared
//    
//    func callService<T:Decodable, S:Encodable>(urlString: String, method: HTTPMethod, body:S, completion: @escaping((Result<T,Error>) -> Void), fail: @escaping(()->Void)) {
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        guard let urlRequest = try? createRequest(method: method, url: url, withBody: body) else {
//            fail()
//            return
//        }
//        debugPrint(urlRequest)
//        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
//            if let data {
//                let json = try? JSONDecoder().decode(T.self, from: data)
//                print(json)
//                completion(.success(json))
//            } else{
//                completion(.failure(Error()))
//            }
//            guard let data else {
//                return
//            }
//            do {
//                
//            } catch {
//                print("Decoding Error : \(error)")
//                fail()
//            }
//        }).resume()
//    }
//    
//    func callVersionAPI<T:Decodable, S:Encodable>(urlString: String, method: HTTPMethod, body:S, sucess: @escaping((T) -> Void), fail: @escaping(()->Void)) {
//        
//        let url = URL(string: urlString)
//        guard let urlObj = url else {
//            return
//        }
//        let urlRequest = try? createRequest(method: method, url: urlObj, withBody: body)
//        guard let request = urlRequest else {
//            fail()
//            return
//        }
//        print(request)
//        session.dataTask(with: request, completionHandler: { (data, response, error) in
//            
//            guard let data = data else {
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                // let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
//                let json = try? decoder.decode(T.self, from: data)
//                print(json as Any)
//                sucess(json as! T)
//            }
//            catch {
//                print("Decoding Error : \(error)")
//                fail()
//            }
////            if let json = try? decoder.decode([T].self, from: data){
////                print(json)
////                sucess(json as! T)
////            }else{
////                fail()
////            }
//        }).resume()
//    }
//    
//    private func createRequest<Body: Encodable>(method: HTTPMethod, url: URL, withBody body: Body) throws -> URLRequest {
//        print(method.rawValue)
//        var newRequest = URLRequest(url: url)
//        newRequest.httpMethod = method.rawValue
//        newRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//        newRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        //newRequest.httpBody = try JSONEncoder().encode(body)
//        return newRequest
//    }
//}
//
//
//
//
// 
