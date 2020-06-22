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
    
    private let baseURL = URL(string: "https://nodeprojectone.herokuapp.com/")
    
    static let shared = BackendController()
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    var dataLoader: DataLoader?
    private var token: Token?
    
    init(dataLoader: DataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
}
