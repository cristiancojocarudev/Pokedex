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
    
    func decode(data: Data) throws -> Response
}

extension DataFetchable {
    var headers: [String : String] {
        [:]
    }
}

extension DataFetchable where Response: Decodable {
    
    func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

protocol NetworkService {
    func fetchData<T: DataFetchable>(fetchable: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

protocol SeriallyFetchableDataContainer: Decodable {
    associatedtype Result
    
    var count: Int { get }
    var next: String? { get }
    var previous: String? { get }
    var results: [Result] { get }
}

extension NetworkService {
    func fetchDataSerially<C: DataFetchable, R: Decodable>(fetchable: C, items: [R], completion: @escaping (Result<[R], Error>) -> Void) {
        var items = items
        self.fetchData(fetchable: fetchable) { result in
            switch result {
            case .success(let response):
                if let response = response as? (any SeriallyFetchableDataContainer),
                    let results = response.results as? [R] {
                        items.append(contentsOf: results)
                        if let next = response.next {
                            var fetchable = fetchable
                            fetchable.url = next
                            self.fetchDataSerially(fetchable: fetchable, items: items) { result in
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
