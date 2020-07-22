//
//  APIManager.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/8/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation
import CoreData

class APIManager {
    
    public static let shared = APIManager()
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndPoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    func request<T: Codable>(url: URL, context: NSManagedObjectContext, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                completion(.failure(.invalidEndPoint))
                return
        }
        
        guard let url = urlComponents.url
            else {
                completion(.failure(.invalidEndPoint))
                return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= statusCode
                else {
                    completion(.failure(.invalidResponse))
                    return
            }
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            //successful
            do {
                self.jsonDecoder.userInfo[CodingUserInfoKey.context!] = context
                let values = try self.jsonDecoder.decode(T.self, from: data!)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}

extension APIManager {
    func getUserList(since: Int, context: NSManagedObjectContext, completion: @escaping (Result<[Profile], APIServiceError>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/users?since=\(since)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        
        request(url: url, context: context, completion: completion)
    }
    
    func getUserProfile(name: String, context: NSManagedObjectContext, completion: @escaping (Result<Profile, APIServiceError>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/users/\(name)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        
        request(url: url, context: context, completion: completion)
    }
    
    
}
