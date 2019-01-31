//
//  ViewController.swift
//  ToDoey
//
//  Created by Yasmine Ghazy on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UIViewController {
    
    //MARK: - Properties
    var itemArray = [Item]()
    var category: Category?
    let defaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
        
        
        
        self.loadItems(isFiltered: false)
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
     This method load items from Sqlite DB using CoreData.
     */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), isFiltered: Bool){
        
        if !isFiltered{
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", (category?.name)!)
            request.predicate = predicate
        }
        
        do{
            itemArray = try context.fetch(request)
            
        }catch {
            print("Error fetching context! ", error)
        }
        
        self.tableView.reloadData()
    }
    
    /**
     This method save items to SQLite DB using CoreData.
     - Parameter items: A list of items to be saved.
     */
    func saveItems(){
        //Path for Sqlite DB.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first) //library/ApplicationSupport
        do {
            try context.save()
        } catch {
            print("Error saving context! ", error)
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new toDoey item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the add button
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? ""
            newItem.done = false
            newItem.parentCategory = self.category
            
            self.itemArray.append(newItem)
            self.saveItems()
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
        
        self.saveItems()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Deleted")
            
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tableView.reloadData()
            self.saveItems()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: - UISearchBarDelegate Methods
extension TodoListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        /**
         In order to make a query we need NSPredicate, Predicate is basically a foundation class that specifies how data should be fetched or filtered.
         It's essentially a query language like some sort of mix bettween SQL Where clause and a regex (Regular expression)
         we add [cd] -> Non sensitive , non diaritics
         */
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (category?.name)!)
        let itemsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, itemsPredicate])
        
        request.predicate = compoundPredicate
        request.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
        
        self.loadItems(with: request, isFiltered: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            self.loadItems(isFiltered: false)
            
            //In order to give a high periority to the search bar in the main thread 
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
