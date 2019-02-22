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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items: [Item] = [Item(name: "Item 1", check: true), Item(name:"Item 2")]
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
        
        // Reload the table
        tableView.reloadData()
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
    
    // MARK: - SearchBar methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBarIsEmpty() == true) {
            return self.items.count
        } else {
            return self.filteredItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        if (searchBarIsEmpty()) {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            cell.accessoryType = item.check ? .checkmark : .none
        } else {
            let item = filteredItems[indexPath.row]
            cell.textLabel?.text = item.name
            cell.accessoryType = item.check ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        items[indexPath.row].toggleCheck()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = items.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(self.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
}
