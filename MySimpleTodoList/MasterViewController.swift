//
//  MasterViewController.swift
//  MySimpleTodoList
//
//  Created by Derek Jensen on 8/30/17.
//  Copyright © 2017 Derek Jensen. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController, DetailViewControllerDelegate {

    var detailViewController: DetailViewController? = nil

    var lists: Results<TodoList> {
        get {
            return TodoListRepository.shared.getTodoLists()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let newListVC = UIAlertController(title: "New TodoList", message: "What is the name of the todo list?", preferredStyle: .alert)
        
        newListVC.addTextField(configurationHandler: {(UITextField) in })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        newListVC.addAction(cancelAction)
        
        let addAction = UIAlertAction.init(title: "Add", style: .default) {
            (UIAlertAction) -> Void in
                let txtTodoListName = (newListVC.textFields?.first)! as UITextField
            
            let newTodoList = TodoList()
            newTodoList.name = txtTodoListName.text!
            
            TodoListRepository.shared.createTodoList(list: newTodoList)
            self.tableView.insertRows(at: [IndexPath.init(row: self.lists.count - 1, section: 0)], with: .automatic)
        }
        
        newListVC.addAction(addAction)
        present(newListVC, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let list = lists[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.delegate = self
                controller.todoListIdentifier = list.id
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let list = lists[indexPath.row]
        cell.textLabel!.text = list.description
        cell.detailTextLabel!.text = "Complete: \(list.complete)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = lists[indexPath.row]

            TodoListRepository.shared.deleteTodoList(list: list)
            self.tableView.reloadData()
        }
    }
}

