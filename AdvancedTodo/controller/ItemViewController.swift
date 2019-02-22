//
//  AddItemViewController.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

protocol ItemViewControllerDelegate {
    func ItemViewControllerDidCancel(_ controller: ItemViewController)
    func ItemViewControllerDone(_ controller: ItemViewController, addingFinish item: Item)
    func ItemViewControllerDone(_ controller: ItemViewController, editingFinish item: Item)
}

class ItemViewController: UITableViewController {
    
    var delegate: ViewController!
    var itemToEdit: Item!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var itemNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((itemToEdit) != nil){
            self.itemNameField.text = itemToEdit?.name
            self.navigationItem.title = "Edit Item"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.itemNameField.becomeFirstResponder()
        self.doneButton.isEnabled = false
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        delegate.ItemViewControllerDidCancel(self)
    }
    
    @IBAction func doneClick(_ sender: Any) {
        if(itemToEdit != nil){
            itemToEdit?.name = self.itemNameField.text!
            delegate?.ItemViewControllerDone(self, editingFinish: itemToEdit!)
        } else {
            delegate.ItemViewControllerDone(self, addingFinish: Item(name: self.itemNameField.text!))
        }
    }
}

extension ItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = itemNameField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        if newString?.isEmpty ?? true {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        return true
    }
}
