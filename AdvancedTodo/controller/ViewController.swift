//
//  ViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = [Item(name: "Item 1", check: true), Item(name:"Item 2")]
    
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
                addItemViewController.itemToEdit = items[indexPath.row]
                addItemViewController.delegate = self
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! ItemViewCell
        let item = items[indexPath.row]
        cell.checkLabel.isHidden = !item.check
        cell.nameLabel.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        items[indexPath.row].toggleCheck()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ViewController: ItemViewControllerDelegate {
    func ItemViewControllerDidCancel(_ controller: ItemViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, addingFinish item: Item) {
        self.dismiss(animated: true, completion: nil)
        self.items.append(item)
        self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .none)
    }
    
    func ItemViewControllerDone(_ controller: ItemViewController, editingFinish item: Item) {
        self.dismiss(animated: false, completion: nil)
        if let row = self.items.firstIndex(where: {$0 === item}) {
            self.items[row] = item
            tableView.reloadRows(at: [IndexPath(row: row, section:0)], with: .none)
        }
    }
  
}

