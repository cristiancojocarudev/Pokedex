//
//  DefaultNetworkService.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 21/02/24.
//

import Foundation

class DefaultNetworkService: NetworkService {
    
    func fetchData<T: DataFetchable>(fetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        guard let url = URL(string: fetchable.url) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = fetchable.method.rawValue
        urlRequest.allHTTPHeaderFields = fetchable.headers
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if !(200..<300 ~= statusCode) {
                    completion(.failure(NetworkError.statusCode(statusCode)))
                    return
                }
            } else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
           
            guard let data = data else {
                completion(.failure(NetworkError.nullData))
                return
            }
            
            do {
                let decodedData = try fetchable.decode(data: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
