//
//  APIClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 5/26/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol APISession {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> APISessionDataTask
}

protocol APISessionDataTask {
    func resume()
}

extension URLSession: APISession {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> APISessionDataTask {
        dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: APISessionDataTask {}

protocol APIClient {
    var session: APISession { get }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> T?, queue: DispatchQueue, completion: ((Result<T, APIError>) -> Void)?)
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> [T]?, queue: DispatchQueue, completion: ((Result<[T], APIError>) -> Void)?)
}

extension APIClient {
    func task(with request: URLRequest, completionHandler completion: @escaping (Swift.Result<Data, APIError>) -> Void) -> APISessionDataTask {
        return session.loadData(with: request) { data, response, error in
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
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> T?, queue: DispatchQueue = .main, completion: ((Result<T, APIError>) -> Void)?) {
        task(with: request) { result in
            queue.async(flags: .barrier) {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let value = parse(data) else {
                        completion?(.failure(.jsonParsingFailed))
                        return
                    }
                    completion?(.success(value))
                }
            }
        }.resume()
    }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> [T]?, queue: DispatchQueue = .main, completion: ((Result<[T], APIError>) -> Void)?) {
        task(with: request) { result in
            queue.async(flags: .barrier) {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let values = parse(data) else {
                        completion?(.failure(.jsonParsingFailed))
                        return
                    }
                    completion?(.success(values))
                }
            }
        }.resume()
    }
}

enum APIError: LocalizedError {
    case incorrectParameters
    case requestFailedWithError(String)
    case requestFailed
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailed
    
    var errorDescription: String {
        switch self {
        case .incorrectParameters: return "Incorrect parameters for request"
        case .requestFailedWithError(let error): return "Request failed with error: \(error)"
        case .requestFailed: return "Request failed"
        case .invalidData: return "Invalid data"
        case .responseUnsuccessful: return "Response unsuccessful"
        case .jsonParsingFailed: return "JSON parsing failed"
        }
    }
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case(.incorrectParameters, .incorrectParameters): return true
        case(.requestFailedWithError, .requestFailedWithError): return true
        case(.requestFailed, .requestFailed): return true
        case(.invalidData, .invalidData): return true
        case(.responseUnsuccessful, .responseUnsuccessful): return true
        case(.jsonParsingFailed, .jsonParsingFailed): return true
        default: return false
        }
    }
}
