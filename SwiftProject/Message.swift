//
//  Message.swift
//  SwiftProject
//
//  Created by Xinbo Lian on 2020/7/17.
//  Copyright © 2020 Xinbo Lian. All rights reserved.
//

import CoreData


class Message: NSManagedObject {
    enum MessageType: Int16 {
        case text = 1
        case image = 2
    }
    
    @NSManaged fileprivate var primitiveType: NSNumber
    
    static let typeKey = "type"
    
    var type: MessageType {
        get {
            willAccessValue(forKey: Message.typeKey)
            guard let val = MessageType(rawValue: primitiveType.int16Value)
                else { fatalError("invalid enum value") }
            didAccessValue(forKey: Message.typeKey)
            return val
        }
        set {
            willChangeValue(forKey: Message.typeKey)
            primitiveType = NSNumber(value: newValue.rawValue)
            didChangeValue(forKey: Message.typeKey)
        }
    }
    
    static func insert(into context: NSManagedObjectContext, type:MessageType) -> Message {
        let msg: Message = context.insertObject()
        msg.type = type
        return msg
    }
    
}
extension Message :Managed
{
    
}
