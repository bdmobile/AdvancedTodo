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
    
    var items: [Item] = [Item(name: "Item 1", check: true), Item(name:"Item 2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
    }
    
    func setupConstraints() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    @IBAction func addItemClick(_ sender: Any) {
        let alerController = UIAlertController(title: "Doing", message: "News Items ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action) in
            self.items.append(Item(name:(alerController.textFields![0] as UITextField).text!))
            self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .none)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alerController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Item Name"
        })
        
        alerController.addAction(cancelAction)
        alerController.addAction(okAction)
        
        present(alerController, animated: true, completion: nil)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.check ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        items[indexPath.row].toggleCheck()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

