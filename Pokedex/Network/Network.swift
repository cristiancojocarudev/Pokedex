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

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
    case nullData
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
