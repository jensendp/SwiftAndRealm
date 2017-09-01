//
//  TodoList.swift
//  MySimpleTodoList
//
//  Created by Derek Jensen on 8/30/17.
//  Copyright © 2017 Derek Jensen. All rights reserved.
//

import Foundation
import RealmSwift

class TodoList: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var complete: Bool {
        if(items.count == 0) {
            return false
        }
        for item in items {
            if !item.complete {
                return false
            }
        }
        return true
    }
    let items = List<TodoItem>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override var description: String {
        return "\(name)"
    }
}
