//
//  NetworkManager.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/06/23.
//

import Foundation
class NetworkManager {
    static let inst = NetworkManager()
    let baseURL = "http://beta.greenvelocity.co.in:8080/cms/manager/rest"
    private init() {}
func postApi(params: [String: Any], endPoint: String,_ completion: @escaping((_ data: Data?,_ error: Error?)-> Void)) {
        var request = URLRequest(url: URL(string: "\(NetworkManager.inst.baseURL)\(endPoint)")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [] )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            completion(data, error)
        })
        task.resume()
    }
    
func getApi(_ endPoint: String, _ completion: @escaping((_ data: Data?, _ errorString: String)->Void)) {
        var request = URLRequest(url: URL(string: NetworkManager.inst.baseURL + endPoint)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if error == nil {
                completion(data, "")
            } else {
                completion(nil, error?.localizedDescription ?? "")
            }
        }).resume()
    }
}
