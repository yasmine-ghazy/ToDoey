//
//  ViewController.swift
//  ToDoey
//
//  Created by Yasmine Ghazy on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UIViewController {
    
    //MARK: - Properties
    var itemArray: Results<Item>?
    var category: Category?
     let realm = try! Realm()

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = category?.name
        self.setupTableView()
        self.setupSearchBar()

        self.loadItems()
    }
    
    //MARK: - Methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func setupSearchBar(){
        self.searchBar.delegate = self
    }
    
    /**
     This method load items from Realm DB.
     */
    func loadItems(){
        
        itemArray = self.category?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
    /**
     This method save items to Realm DB.
     - Parameter items: A list of items to be saved.
     */
    func save(item: Item){
        
        do {
            try realm.write {
                category?.items.append(item)
            }
        } catch {
            print("Error saving realm object! ", error)
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new toDoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the add button
            
            if let category = self.category{
                
            let newItem = Item()
            newItem.title = textField.text ?? ""
            newItem.done = false
            newItem.createDate = Date()
                
            self.save(item: newItem)
            self.tableView.reloadData()
            }
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
        return itemArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = itemArray?[indexPath.row]{
            do{
            try? realm.write {
                 item.done = !item.done
            }
            }catch{
                print("error in updating item.")
            }
           
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Deleted")

            if let item = itemArray?[indexPath.row]{
                RealmDB.delete(object: item)
            }
            self.tableView.reloadData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: - UISearchBarDelegate Methods
extension TodoListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createDate", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            self.loadItems()
            //In order to give a high periority to the search bar in the main thread
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
}
