//
//  TodoItem.swift
//  MySimpleTodoList
//
//  Created by Derek Jensen on 8/30/17.
//  Copyright © 2017 Derek Jensen. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    dynamic var name = ""
    dynamic var complete = false
    
    override var description: String {
        return "\(name): Completed = \(complete)"
    }
}
