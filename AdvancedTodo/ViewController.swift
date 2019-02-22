//
//  ViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var items = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Actions
    @IBAction func addItem(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDoList1", message:"Add new ?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"Ok", style: .default, handler: {(action) in
            
            let textField = alertController.textFields![0] // Force unwrapping because we know it exists.

            self.items.append(TodoItem(textV: textField.text!))
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Item name"
            
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Extension
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        if (items[indexPath.row].checked == true) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = items[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
}

