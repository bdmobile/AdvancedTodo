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
                addItemViewController.itemToEdit = CoreDataManager.instance.categories[indexPath.section].items?.allObjects[indexPath.row] as? Item
                addItemViewController.delegate = self
            }
        }
    }
    
    // MARK: - SearchBar methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
   
    @IBAction func sortItem(_ sender: Any) {
        let alert = UIAlertController(title: "Voulez vous filtrer par :", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
      
        alert.addAction(UIAlertAction(title: "Nom", style: .default, handler: { action in
            CoreDataManager.instance.loadData(query: [NSSortDescriptor(key: "name", ascending: true)])
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Date", style: .default, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Catégorie", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true)
    }
}

extension ListItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CoreDataManager.instance.categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CoreDataManager.instance.categories[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBarIsEmpty() == true) {
            return CoreDataManager.instance.categories[section].items!.count
        } else {
            let rowOfSection = filteredItems.filter { $0.category == CoreDataManager.instance.categories[section] }
            return rowOfSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! ItemViewCell
        
      
        
        if (searchBarIsEmpty()) {
            let item = CoreDataManager.instance.categories[indexPath.section].items?.allObjects[indexPath.row] as! Item
            cell.checkLabel.isHidden = !item.check
            cell.nameLabel.text = item.name
            
        } else {
            let item = filteredItems[indexPath.row]
            cell.checkLabel.isHidden = !item.check
            cell.nameLabel.text = item.name
            cell.detailTextLabel?.text = item.category?.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        (CoreDataManager.instance.categories[indexPath.section].items?.allObjects[indexPath.row] as! Item).toggleCheck()
        tableView.reloadData()
        CoreDataManager.instance.saveData()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item: Item = CoreDataManager.instance.categories[indexPath.section].items?.allObjects[indexPath.row] as! Item
            CoreDataManager.instance.deleteItem(item: item)
            CoreDataManager.instance.categories[indexPath.section].removeFromItems(item)
            self.tableView.reloadData()
            CoreDataManager.instance.saveData()
        }
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
        CoreDataManager.instance.items.append(item)
        self.tableView.reloadData()
        CoreDataManager.instance.saveData()
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, editingFinish item: Item) {
        self.dismiss(animated: false, completion: nil)
        if let row = CoreDataManager.instance.items.firstIndex(where: {$0 === item}) {
            CoreDataManager.instance.items[row] = item
            tableView.reloadData()
            CoreDataManager.instance.saveData()
        }
    }
    
}

extension ListItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = CoreDataManager.instance.items.filter({( item : Item) -> Bool in
            return item.name!.lowercased().contains(self.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
}
