//
//  BackendController.swift
//  BetterProfessor
//
//  Created by Bhawnish Kumar on 6/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

class BackendController {
    
    private let baseURL = URL(string: "https://nodeprojectone.herokuapp.com/")!
    
    static let shared = BackendController()
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    var dataLoader: DataLoader?
    private var token: Token?
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    
       func signUp(username: String, password: String, department: String, completion: @escaping (Bool, URLResponse?, Error?) -> Void) {
            
        // this is where i am assigning the required parameters to the User.swift
            let newUser = User(username: username, password: password, department: department)
            
            let requestURL = baseURL.appendingPathComponent(EndPoints.register.rawValue)
            var request = URLRequest(url: requestURL)
            request.httpMethod = Method.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                
                // Try to encode the newly created user into the request body.
                let jsonData = try encoder.encode(newUser)
                request.httpBody = jsonData
            } catch {
                NSLog("Error encoding newly created user: \(error)")
                return
            }
            // here i am using the customized data loader from the DataLoader file!
            dataLoader?.loadData(from: request) { _, response, error in
                
                if let error = error {
                    NSLog("Error sending sign up parameters to server : \(error)")
                    completion(false, nil, error)
                }
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 500 {
                    NSLog("User already exists in the database. Therefore user data was sent successfully to database.")
                    completion(false, response, nil)
                    return
                }
                
                // We'll only get down here if everything went right
                completion(true, nil, nil)
            }
        }
    
    private enum ProfessorError: Error {
          case noAuth(String)
          case badData(String)
      }
      
      private enum Method: String {
          case get = "GET"
          case post = "POST"
          case put = "PUT"
          case delete = "DELETE"
      }
    
      private enum EndPoints: String {
          case register = "api/auth/register"
          case login = "api/auth/login"
      }
    
      func injectToken(_ token: String) {
          let token = Token(token: token)
        self.token = token
      }
}
