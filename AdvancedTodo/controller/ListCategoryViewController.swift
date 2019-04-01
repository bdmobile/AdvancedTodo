//
//  ListCategoryViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 18/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ListCategoryViewController: UITableViewController, UIGestureRecognizerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("LongPressed \(CoreDataManager.instance.categories[indexPath.row])")
                self.editCategory(category: CoreDataManager.instance.categories[indexPath.row])
            }
        }
    }
    
    @IBAction func addCategoryAction(_ sender: Any) {
        self.editCategory(category: nil)
    }
    
    
    func editCategory(category: Category?) {
        let title = category != nil ? "Mettre à jour" : "Ajouter"
        let alert = UIAlertController(title: "Choisissez un nom de catégorie", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Entrez le nom de la catégorie..."
        })
        
        if (category != nil) {
            alert.textFields?.first?.text = category?.name
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                if (category == nil) {
                    let category = Category(context: CoreDataManager.instance.getContext())
                    category.name = name
                    CoreDataManager.instance.categories.append(category)
                    CoreDataManager.instance.saveData()
                    self.tableView.reloadData()
                } else {
                    category?.name = name
                    if let index = CoreDataManager.instance.categories.index(where: {$0 === category}) {
                        print("Item found at: \(index)")
//                        let indexPath = IndexPath(row: row, section: 0)
//                        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                        CoreDataManager.instance.categories[index] = category!
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension ListCategoryViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return CoreDataManager.instance.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdentifier")!
        
        let category = CoreDataManager.instance.categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.instance.deleteCategory(category: CoreDataManager.instance.categories[indexPath.row])
            CoreDataManager.instance.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.instance.saveData()
        }
    }
    
    
}
