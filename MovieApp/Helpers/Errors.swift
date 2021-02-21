//
//  Errors.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import Foundation

enum GeneralError : LocalizedError {
    case noInternetConnection
    case errorWithMessage(message : String)
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Tidak ada koneksi dengan internet, silahkan kembali mengecek koneksi anda."
        case .errorWithMessage(let msg):
            return msg
        }
    }
}
