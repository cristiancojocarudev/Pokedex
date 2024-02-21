//
//  Network.swift
//  Pokedex
//
//  Created by Cristian Cojocaru on 20/02/24.
//

import Foundation

enum HTTPMethod: String, Decodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
    case nullData
    case invalidSerialCall
}

protocol DataFetchable {
    associatedtype Response
    
    var url: String { get set }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    
    func fetch(data: Data) throws -> Response
}

extension DataFetchable {
    var headers: [String : String] {
        [:]
    }
        
    var queryItems: [String : String] {
        [:]
    }
}

extension DataFetchable where Response: Decodable {
    
    func fetch(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

protocol NetworkService {
    func fetchData<T: DataFetchable>(dataFetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

extension NetworkService {
    func fetchDataSerially<C: DataFetchable, R: Decodable>(fetchable: C, items: [R], completion: @escaping (Result<[R], Error>) -> Void) {
        print(fetchable.url)
        var items = items
        fetchData(dataFetchable: fetchable) { result in
            switch result {
            case .success(let response):
                if let response = response as? (any SeriallyFetchableDataContainer),
                    let results = response.results as? [R] {
                        items.append(contentsOf: results)
                        if let next = response.next {
                            var fetchable = fetchable
                            fetchable.url = next
                            fetchDataSerially(fetchable: fetchable, items: items) { result in
                                completion(result)
                                return
                            }
                        } else {
                            completion(.success(items))
                            return
                        }
                } else {
                    completion(.failure(NetworkError.invalidSerialCall))
                    return
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
}

protocol SeriallyFetchableDataContainer: Decodable {
    associatedtype Result
    
    var count: Int { get }
    var next: String? { get }
    var previous: String? { get }
    var results: [Result] { get }
}
