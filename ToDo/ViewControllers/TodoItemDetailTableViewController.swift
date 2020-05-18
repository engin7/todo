//
//  TodoItemDetailTableViewController.swift
//  ToDo
//
//  Created by Engin KUK on 18.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit


protocol TodoItemDetailTableViewControllerDelegate: class{
 
   func TodoItemDetailTableViewControllerDidCancel( controller: TodoItemDetailTableViewController)
  
   func TodoItemDetailTableViewController( controller: TodoItemDetailTableViewController, didFinishEditing item: Items)
}


class TodoItemDetailTableViewController: UITableViewController {

       weak var delegate: TodoItemDetailTableViewControllerDelegate?
       weak var todoItem: Items?
 
     
    @IBOutlet weak var ItemName: UITextField!
    
    @IBOutlet weak var ItemNotes: UITextView!
  
    @IBAction func cancel(_ sender: Any) {
        
        delegate?.TodoItemDetailTableViewControllerDidCancel(controller: self)

    }
    
    
    @IBAction func saveItemDetails(_ sender: Any) {
        
        if let item = todoItem, let text = ItemName.text, let note = ItemNotes.text {
                   item.name = text
                   item.notes = note
                   delegate?.TodoItemDetailTableViewController(controller: self, didFinishEditing: item)
               }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       if let item = todoItem {
        
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

extension TodoItemDetailTableViewController: UITextFieldDelegate {
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     ItemName.resignFirstResponder()
       return false
   }
 
}
