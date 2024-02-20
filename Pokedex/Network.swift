//
//  Network.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 20/02/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataFetchable {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    
    func fetch(data: Data) throws -> Response
}

extension DataFetchable where Response: Decodable {
    var headers: [String : String] {
        [:]
    }
        
    var queryItems: [String : String] {
        [:]
    }
    
    func fetch(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

protocol NetworkService {
    func fetchData<T: DataFetchable>(dataFetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

class DefaultNetworkService: NetworkService {
    
    func fetchData<T: DataFetchable>(dataFetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: dataFetchable.url) else {
            let error = NSError(
                domain: "invalidEndpoint",
                code: 404,
                userInfo: nil
            )
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        dataFetchable.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: "invalidEndpoint",
                code: 404,
                userInfo: nil
            )
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = dataFetchable.method.rawValue
        urlRequest.allHTTPHeaderFields = dataFetchable.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            do {
                try completion(.success(dataFetchable.fetch(data: data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

