//
//  DetailViewController.swift
//  MySimpleTodoList
//
//  Created by Derek Jensen on 8/30/17.
//  Copyright © 2017 Derek Jensen. All rights reserved.
//

import UIKit
import RealmSwift

protocol DetailViewControllerDelegate: class {
    func reloadTableView()
}

class TodoListItemCell: UITableViewCell {
    
    @IBOutlet weak var txtItemName: UILabel!
    @IBOutlet weak var switchItemCompleted: UISwitch!
}

class DetailViewController: UITableViewController {

    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var list: TodoList? {
        get {
            return TodoListRepository.shared.getTodoList(id: todoListIdentifier!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = list?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var todoListIdentifier: String?

    @IBAction func addItem(_ sender: Any) {
        let newItemVC = UIAlertController(title: "New TodoList Item", message: "What is the name of the todo list item?", preferredStyle: .alert)
        
        newItemVC.addTextField(configurationHandler: {(UITextField) in })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        newItemVC.addAction(cancelAction)
        
        let addAction = UIAlertAction.init(title: "Add", style: .default) {
            (UIAlertAction) -> Void in
            let txtTodoListName = (newItemVC.textFields?.first)! as UITextField
            
            let newTodoListItem = TodoItem()
            newTodoListItem.name = txtTodoListName.text!
            
            TodoListRepository.shared.addItemToTodoList(list: self.list!, item: newTodoListItem)
            self.tableView.insertRows(at: [IndexPath.init(row: (self.list?.items.count)! - 1, section: 0)], with: .automatic)
            self.delegate?.reloadTableView()
        }
        
        newItemVC.addAction(addAction)
        present(newItemVC, animated: true, completion: nil)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list?.items.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! TodoListItemCell
        
        cell.switchItemCompleted.addTarget(self, action: #selector(itemCompleted(sender:)), for: .valueChanged)
        cell.switchItemCompleted.tag = indexPath.row
        
        let item = self.list?.items[indexPath.row]
        cell.txtItemName!.text = item?.name
        cell.switchItemCompleted.isOn = (item?.complete)!
        
        
        return cell
    }
    
    func itemCompleted(sender: UISwitch) {
        let updatedItem = list?.items[sender.tag]
        
        TodoListRepository.shared.updateItemCompletionStatus(item: updatedItem!, isComplete: sender.isOn)
        self.tableView.reloadData()
        self.delegate?.reloadTableView()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoListRepository.shared.removeItemFromTodoList(list: list!, itemAtIndex: indexPath.row)
            self.tableView.reloadData()
            self.delegate?.reloadTableView()
        }
    }

    
}

