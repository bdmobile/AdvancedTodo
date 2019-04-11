//
//  SelectCategoryViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 01/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UITableViewController {
    
    var setCategoryHandler: ((UIViewController, Category) -> ())!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.instance.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryIdentifier")!
        
        cell.textLabel?.text =  CoreDataManager.instance.categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        setCategoryHandler(self,CoreDataManager.instance.categories[indexPath.row])
    }
}
