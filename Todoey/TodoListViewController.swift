//
//  ViewController.swift
//  Todoey
//
//  Created by Ben Lapidge on 05/01/2023.
//

import UIKit

class TodoListViewController: UITableViewController {
    let itemArray = ["Complete Course", "Get Job", "Release Metroid Prime 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
//MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

