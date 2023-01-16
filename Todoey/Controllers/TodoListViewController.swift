//
//  ViewController.swift
//  Todoey
//
//  Created by Ben Lapidge on 05/01/2023.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Access NSContainer declared in AppDelegate. Does this by allowing access to AppDelegate as an objet rather than class.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row].title
        
        cell.contentConfiguration = content
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // TODO: - Remove when tapped, uncomment to enable
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what happens once user clicks add item button UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    // MARK: - SearchBar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if searchBar.text?.count == 0{
            loadItems()
        } else {
            loadItems(with: request)
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
}
