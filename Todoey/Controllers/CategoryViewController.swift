//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ben Lapidge on 16/01/2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [ToDoCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { action in
            // what happens once user clicks add item button UIAlert
            
            let newCategory = ToDoCategory(context: self.context)
            newCategory.name = textField.text!
        
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = categoryArray[indexPath.row].name
        
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        // TODO: - Remove when tapped, uncomment to enable
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        self.saveCategories()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        tableView.reloadData()
    }
}
