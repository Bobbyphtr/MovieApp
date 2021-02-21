//
//  NetworkManager.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    let session : Session
    
    private init() {
        session = Session()
    }
    
}

extension NetworkManager {
    static func decode<T>(data:Data?, modelType: T.Type) ->AnyObject? where T : Decodable  {
        do{
            if data == nil { return nil}
//            print("<----------" + String(data: data!, encoding: String.Encoding.utf8)!)
            return try JSONDecoder().decode(modelType, from: data!) as AnyObject?
        }catch let error{
            print(error)
        }
        return nil
    }
    
    static func printData(response : AFDataResponse<Data>) {
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
        }
    }
}
