//
//  APIClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 5/26/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> T?, completion: ((Result<T, APIError>) -> Void)?)
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> [T]?, completion: ((Result<[T], APIError>) -> Void)?)
}

extension APIClient {
    
    func task(with request: URLRequest, completionHandler completion: @escaping (Swift.Result<Data, APIError>) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailedWithError(error.localizedDescription)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.responseUnsuccessful))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.invalidData))
            }
        }
    }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> T?, completion: ((Result<T, APIError>) -> Void)?) {
        task(with: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let value = parse(data) else {
                        completion?(.failure(.jsonParsingFailure))
                        return
                    }
                    completion?(.success(value))
                }
            }
        }.resume()
    }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> [T]?, completion: ((Result<[T], APIError>) -> Void)?) {
        task(with: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let values = parse(data) else {
                        completion?(.failure(.jsonParsingFailure))
                        return
                    }
                    completion?(.success(values))
                }
            }
        }.resume()
    }
}

enum APIError: Error {
    case requestFailedWithError(String)
    case requestFailed
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailedWithError(let error): return "Request failed with error: \(error)"
        case .requestFailed: return "Request failed"
        case .invalidData: return "Invalid data"
        case .responseUnsuccessful: return "Response unsuccessful"
        case .jsonParsingFailure: return "JSON parsing failure"
        }
    }
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case(.requestFailedWithError, .requestFailedWithError): return true
        case(.requestFailed, .requestFailed): return true
        case(.invalidData, .invalidData): return true
        case(.responseUnsuccessful, .responseUnsuccessful): return true
        case(.jsonParsingFailure, .jsonParsingFailure): return true
        default: return false
        }
    }
}
