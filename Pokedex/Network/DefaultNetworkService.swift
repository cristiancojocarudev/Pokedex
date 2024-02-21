//
//  DefaultNetworkService.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 21/02/24.
//

import Foundation

class DefaultNetworkService: NetworkService {
    
    func fetchData<T: DataFetchable>(dataFetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        
       guard var urlComponents = URLComponents(string: dataFetchable.url) else {
           completion(.failure(NetworkError.invalidUrl))
           return
        }
        
        urlComponents.queryItems = []
        dataFetchable.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponents.queryItems?.append(urlQueryItem)
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = dataFetchable.method.rawValue
        urlRequest.allHTTPHeaderFields = dataFetchable.headers
        
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
                let fetchedData = try dataFetchable.fetch(data: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
