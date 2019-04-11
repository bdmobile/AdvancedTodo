//
//  ViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class ListItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var fetchController: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchController = CoreDataManager.instance.filterCategories()
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
             self.tableView.reloadData()
        } catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        fetchController = CoreDataManager.instance.filterCategories()
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            self.tableView.reloadData()
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem") {
            let itemViewController = (segue.destination as! UINavigationController).topViewController as! ItemViewController
            itemViewController.delegate = self
        } else if (segue.identifier == "editItem") {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                let addItemViewController = (segue.destination as! UINavigationController).topViewController as! ItemViewController
                addItemViewController.itemToEdit = fetchController.object(at: indexPath)
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
            self.fetchController = CoreDataManager.instance.filterCategories(sortByItemName: true)
            do {
                try self.fetchController.performFetch()
                self.tableView.reloadData()
            } catch {
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Date", style: .default, handler: { action in
            self.fetchController = CoreDataManager.instance.filterCategories(sortByDate: true)
            do {
                try self.fetchController.performFetch()
                self.tableView.reloadData()
            } catch {
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Catégorie", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true)
    }
}

extension ListItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return fetchController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchController.sections![section].name
        //return CoreDataManager.instance.categories[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionInfo = fetchController.sections?[section]  else { return 0 }
        
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! ItemViewCell
        
        let item = fetchController.object(at: indexPath)
        
        if(item.name != nil){
        cell.checkLabel.isHidden = !item.check
        cell.nameLabel.text = item.name
        cell.dateLabel.text = formatDate(date: item.dateUpdate!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        fetchController.object(at: indexPath).toggleCheck()
        do {
            try fetchController.performFetch()
        } catch {
            
        }
        tableView.reloadData()
        CoreDataManager.instance.saveData()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item: Item = fetchController.object(at: indexPath)
            CoreDataManager.instance.deleteItem(item: item)
            do {
                try fetchController.performFetch()
                self.tableView.reloadData()
            } catch {
                
            }
            CoreDataManager.instance.saveData()
        }
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "en")
        let dateString = formatter.string(from: date)
        
        return dateString
    }
}

extension ListItemViewController: ItemViewControllerDelegate {
    func ItemViewControllerDidCancel(_ controller: ItemViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, addingFinish item: Item) {
        self.searchBar.text = ""
        self.dismiss(animated: true, completion: nil)
        CoreDataManager.instance.items.append(item)
        do {
            try fetchController.performFetch()
            self.tableView.reloadData()
        } catch {
            
        }
        CoreDataManager.instance.saveData()
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, editingFinish item: Item) {
        self.dismiss(animated: false, completion: nil)
        if let row = CoreDataManager.instance.items.firstIndex(where: {$0 === item}) {
            CoreDataManager.instance.items[row] = item
            do {
                try fetchController.performFetch()
                self.tableView.reloadData()
            } catch {
                
            }
            CoreDataManager.instance.saveData()
        }
    }
    
}

extension ListItemViewController: UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        fetchController = CoreDataManager.instance.filterCategories(filter: searchText)
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            tableView.reloadData()
        } catch {
            
        }
        
        
    }
}
