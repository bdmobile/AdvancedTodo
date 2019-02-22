//
//  ViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ListItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem") {
            let itemViewController = (segue.destination as! UINavigationController).topViewController as! ItemViewController
            itemViewController.delegate = self
        } else if (segue.identifier == "editItem") {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                let addItemViewController = (segue.destination as! UINavigationController).topViewController as! ItemViewController
                addItemViewController.itemToEdit = SaveDataManager.instance.lists[indexPath.row]
                addItemViewController.delegate = self
            }
        }
    }
    
    // MARK: - SearchBar methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
}

extension ListItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBarIsEmpty() == true) {
            return SaveDataManager.instance.lists.count
        } else {
            return self.filteredItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! ItemViewCell
        if (searchBarIsEmpty()) {
            let item = SaveDataManager.instance.lists[indexPath.row]
            cell.checkLabel.isHidden = !item.check
            cell.nameLabel.text = item.name
            
        } else {
            let item = filteredItems[indexPath.row]
            cell.checkLabel.isHidden = !item.check
            cell.nameLabel.text = item.name
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        SaveDataManager.instance.lists[indexPath.row].toggleCheck()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ListItemViewController: ItemViewControllerDelegate {
    func ItemViewControllerDidCancel(_ controller: ItemViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, addingFinish item: Item) {
        self.searchBar.text = ""
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
        SaveDataManager.instance.lists.append(item)
        self.tableView.insertRows(at: [IndexPath(row: SaveDataManager.instance.lists.count-1, section: 0)], with: .none)
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, editingFinish item: Item) {
        self.dismiss(animated: false, completion: nil)
        if let row = SaveDataManager.instance.lists.firstIndex(where: {$0 === item}) {
            SaveDataManager.instance.lists[row] = item
            tableView.reloadRows(at: [IndexPath(row: row, section:0)], with: .none)
        }
    }
  
}

extension ListItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = SaveDataManager.instance.lists.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(self.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
}