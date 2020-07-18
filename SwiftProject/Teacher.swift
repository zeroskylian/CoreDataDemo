//
//  Teacher.swift
//  SwiftProject
//
//  Created by Xinbo Lian on 2020/7/16.
//  Copyright © 2020 Xinbo Lian. All rights reserved.
//

import CoreData

class Teacher: NSManagedObject {
    @NSManaged var name :String
    @NSManaged var id : Int16
    @NSManaged fileprivate(set) var students: Set<Student>
    
    static func findOrCreate(for teacherId: Int16, name : String, in context: NSManagedObjectContext) -> Teacher {
        let predicate = Teacher.predicate(format: "%K == %d", #keyPath(id), teacherId)
        let teacher = findOrCreate(in: context, matching: predicate) {
            $0.id = teacherId
            $0.name = name
        }
        return teacher
    }
}

extension Teacher : Managed {
    
}
