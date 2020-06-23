//
//  Student+Convenience.swift
//  BetterProfessor
//
//  Created by Stephanie Ballard on 6/22/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

extension Student {
    @discardableResult convenience init(name: String,
                                        studentID: Int64,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.studentID = studentID
    }
}
