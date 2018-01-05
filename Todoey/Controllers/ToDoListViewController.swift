//
//  ViewController.swift
//  Todoey
//
//  Created by Aaron Phillips on 31/12/2017.
//  Copyright © 2017 Aaron Phillips. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray =  [Todo]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todo = Todo()
        todo.label = "Destroy Voldemort"
        itemArray.append(todo)
        let todo2 = Todo()
        todo2.label = "Practice spells"
        itemArray.append(todo2)
        let todo3 = Todo()
        todo3.label = "Win quiddich"
        itemArray.append(todo3)
        
        loadItems()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let todo = itemArray[indexPath.row]
        
        cell.textLabel?.text = todo.label
        
        cell.accessoryType = todo.isChecked == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Utem", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            let todo = Todo()
            todo.label = textField.text!
            
            self.itemArray.append(todo)
            
            self.saveItems()
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("error encoding item array")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try decoder.decode([Todo].self, from: data)
            }
            catch {
                print("error decoding item")
            }
        }
    }
}

