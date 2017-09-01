//
//  TodoListRepository.swift
//  MySimpleTodoList
//
//  Created by Derek Jensen on 8/31/17.
//  Copyright © 2017 Derek Jensen. All rights reserved.
//

import Foundation
import RealmSwift

class TodoListRepository {
    
    private var realm: Realm!
    
    static let shared = TodoListRepository()
    
    func getTodoLists() -> Results<TodoList> {
        return realm.objects(TodoList.self)
    }
    
    func getTodoList(id: String) -> TodoList? {
        return realm.object(ofType: TodoList.self, forPrimaryKey: id)
    }
    
    func createTodoList(list: TodoList) {
        try! self.realm.write({
            realm.add(list)
        })
    }
    
    func updateTodoList(list: TodoList) {
        try! self.realm.write({
            realm.add(list, update: true)
        })
    }
    
    func addItemToTodoList(list: TodoList, item: TodoItem) {
        try! self.realm.write({
            list.items.append(item)
        })
    }
    
    func removeItemFromTodoList(list: TodoList, itemAtIndex: Int) {
        try! self.realm.write({
            list.items.remove(objectAtIndex: itemAtIndex)
        })
    }
    
    func updateItemCompletionStatus(item: TodoItem, isComplete: Bool) {
        try! self.realm.write({
            item.complete = isComplete
        })
    }
    
    func deleteTodoList(list: TodoList) {
        try! self.realm.write({
            for item in list.items {
                realm.delete(item)
            }
            
            realm.delete(list)
        })
    }
    
    private init() {
        realm = try! Realm()
    }
    
}
