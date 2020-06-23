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
    
    private let baseURL = URL(string: "https://betterprofessoruni.herokuapp.com")!
    
    static let shared = BackendController()

    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    var dataLoader: DataLoader?
    private var token: Token?
    var instructorStudent: [Student] = []

    let bgContext = CoreDataStack.shared.container.newBackgroundContext()
    let operationQueue = OperationQueue()
    // this will check if the user is signed in
    var isSignedIn: Bool {
        return token != nil

    }

    var userID: Int64? {
        didSet {
            loadInstructorStudent()
        }
    }

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
    
    func signIn(username: String, password: String, completion: @escaping (Bool) -> Void) {

        let requestURL = baseURL.appendingPathComponent(EndPoints.login.rawValue)
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Try to create a JSON from the passaed in parameters, and embedding it into requestHTTPBody.
            let dictionary = ["username": username, "password": password]
            let jsonData = try jsonFromDict(dictionary: dictionary)
            request.httpBody = jsonData
        } catch {
            NSLog("Error in getting JSON Data: \(error)")
            return
        }
        dataLoader?.loadData(from: request, completion: { data, response, error in
            if let error = error {
                NSLog("Error in loading data: \(error)")
                completion(self.isSignedIn)
                return
            }

            guard let data = data else {
                NSLog("Invalid data received while loggin in.")
                completion(self.isSignedIn)
                return
            }
            self.bgContext.perform {
                do {
                    let decodedUser = try self.decoder.decode(User.self, from: data)
                    self.userID = decodedUser.id
                    NSLog("⭐️ \(self.userID)")
                    let tokenResult = try self.decoder.decode(Token.self, from: data)
                    self.token = tokenResult
                    NSLog("✅ \(self.token)")
                    completion(self.isSignedIn)
                } catch {
                    NSLog("Error in catching the token: \(error)")
                    completion(self.isSignedIn)
                }
            }
        })
    }

    private func loadInstructorStudent(completion: @escaping (Bool, Error?) -> Void = { _, _ in}) {
        guard let token = token, let id = userID else {
            completion(false, ProfessorError.noAuth("UserID hasn't been assigned"))
            return
        }

        let requestURL = baseURL.appendingPathComponent("\(EndPoints.students.rawValue)").appendingPathComponent("\(id)/students")
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.get.rawValue
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        
        dataLoader?.loadData(from: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching logged in user's course : \(error)")
                completion(false, error)
                return
            }

            guard let data = data else {
                completion(false, ProfessorError.badData("Received bad data when fetching logged in user's student array."))
                return
            }
            // changed
            let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()

            let handleFetchedStudent = BlockOperation {
                do {
                    let decodedStudent = try self.decoder.decode([StudentRepresentation].self, from: data)
                    // Check if the user has no student. And if so return right here.
                    if decodedStudent.isEmpty {
                        NSLog("User has no Student in the database.")
                        completion(true, nil)
                        return
                    }
                    // If the decoded student array isn't empty
                    for student in decodedStudent {
                        guard let studentId = student.id else { return }
                        // swiftlint:disable all
                        let nsID = NSNumber(integerLiteral: Int(studentId))
                        // swiftlint:enable all
                        fetchRequest.predicate = NSPredicate(format: "id == %@", nsID)
                        // If fetch request finds a student, add it to the array and update it in core data
                        let foundStudent = try self.bgContext.fetch(fetchRequest).first
                        if let foundStudent = foundStudent {
                            self.update(student: foundStudent, with: student)
                            // Check if student has already been added.
                            if self.instructorStudent.first(where: { $0 == foundStudent }) != nil {
                                NSLog("Student already added to user's course.")
                            } else {
                                self.instructorStudent.append(foundStudent)
                            }
                        } else {
                            //                             If the student isn't in core data, add it.
                            if let newStudent = Student(representation: student, context: self.bgContext) {
                                if self.instructorStudent.first(where: { $0 == newStudent }) != nil {
                                    NSLog("Student already added to user's course.")
                                } else {
                                    self.instructorStudent.append(newStudent)
                                }
                            }

                        }
                    }
                } catch {
                    do {
                        let error = try self.decoder.decode(Dictionary<String, String>.self, from: data)
                        NSLog("Error: \(error)")
                    } catch {

                        NSLog("Error Decoding Student, Fetching from Coredata: \(error)")
                        completion(false, error)
                    }
                }
            }

            let handleSaving = BlockOperation {
                // After going through the entire array, try to save context.
                // Make sure to do this in a separate do try catch so we know where things fail
                let handleSaving = BlockOperation {
                    do {
                        // After going through the entire array, try to save context.
                        // Make sure to do this in a separate do try catch so we know where things fail
                        try CoreDataStack.shared.save(context: self.bgContext)
                        completion(false, nil)
                    } catch {
                        NSLog("Error saving context. \(error)")
                        completion(false, error)
                    }
                }
                self.operationQueue.addOperations([handleSaving], waitUntilFinished: true)
            }
            handleSaving.addDependency(handleFetchedStudent)
            self.operationQueue.addOperations([handleFetchedStudent, handleSaving], waitUntilFinished: true)
        }
    }

    func forceLoadInstructorStudents(completion: @escaping (Bool, Error?) -> Void) {
        loadInstructorStudent(completion: { isEmpty, error in
            completion(isEmpty, error)
        })
    }

    func createStudentForInstructor(name: String, email: String, subject: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let token = token,
            let id = self.userID else { return }
        let requestURL = baseURL.appendingPathComponent(EndPoints.students.rawValue).appendingPathComponent("\(id)/students")
        var request = URLRequest(url: requestURL)
        request.httpMethod = Method.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token.token, forHTTPHeaderField: "Authorization")

        do {
            let dictionary: [String: Any] = ["name": name,
                                             "email": email,
                                             "subject": subject,
                                             "teacher_id": "\(id)"]
            let jsonBody = try jsonFromDict(dictionary: dictionary)
            request.httpBody = jsonBody
        } catch {
            completion(false, error)
        }

        dataLoader?.loadData(from: request, completion: { _, _, error in
            if let error = error {
                completion(false, error)
                return
            }

            completion(true, nil)
        })
    }

    private func update(student: Student, with rep: StudentRepresentation) {
        student.name = rep.name
    }

    private func jsonFromDict(dictionary: Dictionary<String, Any>) throws -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON from Dictionary. \(error)")
            throw error
        }
    }

    private func jsonFromUsername(username: String) throws -> Data? {
        var dic: [String: String] = [:]
        dic["username"] = username

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return jsonData
        } catch {
            NSLog("Error Creating JSON From username dictionary. \(error)")
            throw error
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
        case students = "/api/users/teacher/"
    }
    
    func injectToken(_ token: String) {
        let token = Token(token: token)
        self.token = token
    }
}
