//
//  NetworkManager.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import Foundation

enum NetworkManagerError: Error {
    case invalidUrl
}

extension NetworkManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL.\nCan't convert string to URL."
        }
    }
}



class NetworkManager {
    
    func getData(from urlString: String) async throws -> Data {
        
        var data: (Data, URLResponse)
        
        guard let url = URL(string: urlString) else { throw NetworkManagerError.invalidUrl }
        
        do {
            data = try await URLSession.shared.data(from: url)
        } catch {
            throw error
        }
        
        return data.0
    }
}
