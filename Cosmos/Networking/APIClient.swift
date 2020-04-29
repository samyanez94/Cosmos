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
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.responseUnsuccessful))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> T?, queue: DispatchQueue = .main, completion: ((Result<T, APIError>) -> Void)?) {
        task(with: request) { result in
            queue.async {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let value = parse(data) else {
                        completion?(.failure(.jsonParsingError))
                        return
                    }
                    completion?(.success(value))
                }
            }
        }.resume()
    }
    
    func fetch<T: Decodable>(with request: URLRequest, parse: @escaping (Data) -> [T]?, queue: DispatchQueue = .main, completion: ((Result<[T], APIError>) -> Void)?) {
        task(with: request) { result in
            queue.async {
                switch result {
                case .failure(let error):
                    completion?(.failure(error))
                case .success(let data):
                    guard let values = parse(data) else {
                        completion?(.failure(.jsonParsingError))
                        return
                    }
                    completion?(.success(values))
                }
            }
        }.resume()
    }
}
