//
//  ViewController.swift
//  ToDoey
//
//  Created by Yasmine Ghazy on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import UIKit

class TodoListVC: UIViewController {

    //MARK: - Properties
    var itemArray = [Item]()
    let defaults = UserDefaults()
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        self.loadData()
    }
    
    //MARK: - Methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func loadData(){
        
        if let data = defaults.array(forKey: "TodoList") as? [Item]{
            self.itemArray = data
        }
    }
    
    func saveData(){
        self.defaults.set(self.itemArray, forKey: "TodoList")
    }
    
    //MARK: - IBActions
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new toDoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add button
            let newItem = Item(title: textField.text ?? "")
            self.itemArray.append(newItem)
           // self.saveData()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Tableview Delegate and DataSource
extension TodoListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.tableView.reloadData()
        
        //self.saveData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
