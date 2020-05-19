//
//  TodoItemDetailTableViewController.swift
//  ToDo
//
//  Created by Engin KUK on 18.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

protocol  DetailTableViewControllerDelegate: class{
 
   func  DetailTableViewControllerDidCancel( controller: DetailTableViewController)
  
   func  DetailTableViewController( controller: DetailTableViewController, didFinishEditing item: todoItem)
}


class DetailTableViewController: UITableViewController {

        weak var delegate: DetailTableViewControllerDelegate?
        weak var ToDoItem: todoItem?
 
     
    @IBOutlet weak var ItemName: UITextField!
    @IBOutlet weak var ItemNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    @IBAction func cancel(_ sender: Any) {
    
        delegate?.DetailTableViewControllerDidCancel(controller: self)

    }
    
    
    @IBAction func saveItemDetails(_ sender: Any) {
    
         if let item = ToDoItem, let text = ItemName.text, let note = ItemNotes.text {
                   item.name = text
                   item.notes = note
                   delegate?.DetailTableViewController(controller: self, didFinishEditing: item)
               }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       if let item = ToDoItem {
        
        title = "Edit Item"
       
        ItemName.text = item.name
        ItemNotes.text = item.notes
        
        }
       navigationItem.largeTitleDisplayMode = .never
       ItemName.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
          
         ItemNotes.layer.cornerRadius = 5
         ItemNotes.layer.borderColor = UIColor.lightGray.cgColor
         ItemNotes.layer.borderWidth = 1
        
          ItemName.becomeFirstResponder()
       }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
  }
  
}

    // MARK: - Extensions

extension DetailTableViewController: UITextFieldDelegate {
   
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         ItemName.resignFirstResponder()
           return false
       }
     
        //avoid very short entries
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           guard let oldText = ItemName.text,
               let stringRange = Range(range, in: oldText) else {
             return false
           }
           
           let newText = oldText.replacingCharacters(in: stringRange, with: string)
           if newText.count < 4 {
               saveButton.isEnabled = false
           } else {
               saveButton.isEnabled = true
           }
               return true
   }
    
}
