//
//  Student.swift
//  SwiftProject
//
//  Created by Xinbo Lian on 2020/7/16.
//  Copyright © 2020 Xinbo Lian. All rights reserved.
//

import CoreData

class Student: NSManagedObject {
    @NSManaged fileprivate(set) var name :String
    @NSManaged fileprivate(set) var id : Int16
    @NSManaged public fileprivate(set) var teacher: Teacher
    
    
    static func insert(into context: NSManagedObjectContext, name: String, id:Int16, teacherID:Int16,teacherName:String) -> Student {
        let stu: Student = context.insertObject()
        stu.name = name
        stu.id = id
        stu.teacher = Teacher.findOrCreate(for: teacherID, name: teacherName, in: context)
        return stu
    }
}

extension Student : Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: false)]
    }
}
