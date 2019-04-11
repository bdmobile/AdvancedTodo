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

class ItemViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ListItemViewController!
    var itemToEdit: Item!
    var itemToCreate: Item!
    let imagePicker = UIImagePickerController()
    let context = CoreDataManager.instance.persistentContainer.viewContext
    
    @IBOutlet weak var categoryCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectCategory") {
            let selectCategoryViewController = segue.destination as! SelectCategoryViewController
            selectCategoryViewController.setCategoryHandler = self.setCategory
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        if((itemToEdit) != nil){
            self.itemNameField.text = itemToEdit?.name
            self.navigationItem.title = "Edit Item"
            if let category = itemToEdit.category {
                self.categoryCell.textLabel?.text = category.name
            }
            if let image = itemToEdit.image {
                let imageWithData = UIImage(data: image.data!)
                self.imageView.image = imageWithData
            }
        } else {
           
            
            itemToCreate = Item(context: context)
            
            self.categoryCell.textLabel?.text = "Select Category"
        
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.itemNameField.becomeFirstResponder()
        if((itemToEdit) != nil){
            self.doneButton.isEnabled = true
        } else {
            self.doneButton.isEnabled = false
        }
        
        if((itemNameField.text) != ""){
            self.doneButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if(indexPath.section == 1 && indexPath.row == 1){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            let imageBin = image.jpegData(compressionQuality: 1)
            if(itemToEdit != nil){
                self.itemToEdit.image?.data = imageBin
                self.itemToEdit.image?.dateUpdate = Date()
            } else {
                let finnalyImage = Image(context: context)
                
                finnalyImage.data = imageBin
                finnalyImage.dateCrea = Date()
                finnalyImage.dateUpdate = Date()
                
                self.itemToCreate.image = finnalyImage
            }
            
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        delegate.ItemViewControllerDidCancel(self)
    }
    
    @IBAction func doneClick(_ sender: Any) {
        if(itemToEdit != nil){
            itemToEdit?.name = self.itemNameField.text!
            itemToEdit.dateUpdate = Date()
            
            delegate?.ItemViewControllerDone(self, editingFinish: itemToEdit!)
        } else {
           
            itemToCreate.name = self.itemNameField.text!
            itemToCreate.dateCrea = Date()
            itemToCreate.dateUpdate = Date()
            
            
            delegate.ItemViewControllerDone(self, addingFinish: itemToCreate)
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

private extension ItemViewController {
    func setCategory(view: UIViewController, category: Category) {
        self.navigationController?.popViewController(animated: true)
        if(itemToEdit != nil){
            self.itemToEdit?.category = category
        } else {
            self.itemToCreate.category = category
        }
        self.categoryCell.textLabel?.text = category.name
    }
}
