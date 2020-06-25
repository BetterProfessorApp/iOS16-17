//
//  Project.swift
//  BetterProfessor
//
//  Created by Hunter Oppel on 6/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

struct Project: Codable {
    let projectID: Int
    let projectName: String
    let dueDate: Date
    let studentID: String
    let studentName: String
    let projectType: String
    let description: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case projectID = "id"
        case projectName
        case dueDate
        case studentID
        case studentName = "name"
        case projectType
        case description = "desc"
        case completed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.projectID = try container.decode(Int.self, forKey: .projectID)
        self.projectName = try container.decode(String.self, forKey: .projectName)
        self.studentID = try container.decode(String.self, forKey: .studentID)
        self.studentName = try container.decode(String.self, forKey: .studentName)
        self.projectType = try container.decode(String.self, forKey: .projectType)
        self.description = try container.decode(String.self, forKey: .description)
        self.dueDate = try container.decode(Date.self, forKey: .dueDate)

        let completedInt = try container.decode(Int.self, forKey: .completed)
        if completedInt == 0 {
            self.completed = false
            return
        } else {
            self.completed = true
        }
    }
}
