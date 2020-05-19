//
//  ToDoListViewController.swift
//   
//
//  Created by Engin KUK on 18.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

   private let appDelegate = UIApplication.shared.delegate as! AppDelegate
   private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   private var items = [todoItem]()
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBAction func addItem(_ sender: Any) {
        
      let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
      alert.addTextField { (textField) in
          textField.placeholder = "Create New Item"
          textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControl.Event.editingChanged)
      }
      let action = UIAlertAction(title: "Save", style: .default) { (action) in
          
          let newItem = todoItem(context: self.context)
          newItem.name = alert.textFields![0].text!
          newItem.done = false
          newItem.notes = ""
          self.items.append(newItem)
          self.saveItems()
       
      }
      action.isEnabled = false
      
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
   
    }
  
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
             for indexPath in selectedRows {
                let rowToDelete = indexPath.row > items.count-1 ? items.count-1 : indexPath.row
                let item = items[rowToDelete]
                
                items.remove(at: rowToDelete)
                context.delete(item)
                }
                deleteButton.isEnabled = false
                
                tableView.beginUpdates()
                tableView.deleteRows(at: selectedRows, with: .automatic)
                tableView.endUpdates()
                 
             }
                 saveItems()
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        deleteButton.isEnabled = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.accessibilityIdentifier = "List todos"
        addButton.accessibilityLabel = "Add"
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchItems()
       }
    
    // alert textfield restriction
    
     @objc func alertTextFieldDidChange(field: UITextField){
             let alertController:UIAlertController = self.presentedViewController as! UIAlertController
             let textField :UITextField  = alertController.textFields![0]
             let addAction: UIAlertAction = alertController.actions[0]
             addAction.isEnabled = (textField.text?.count)! > 3

         }
    
    // MARK: - CoreData Methods
    
    
    // fetch from CoreData
    
        func fetchItems(){

         do {
           items = try context.fetch(todoItem.fetchRequest())
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
            self.tableView.reloadData()
        }
    
    // save to CoreData
    
     func saveItems(){
    
          do{
              try context.save()
          }catch {
              print("Error saving context with \(error)")
          }
           self.tableView.reloadData()
      }
     
      
    // MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ToDoListTableViewCell
        
         let item = items[indexPath.row]
         cell.name.text = item.name
         cell.check.isHighlighted = item.done
    
        cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
        return cell
    }
    
    // MARK: - TableView Delegate Methods
       
    
    // enable editing mode:
    
       override func setEditing(_ editing: Bool, animated: Bool) {
           super.setEditing(editing, animated: true)
           tableView.setEditing(tableView.isEditing, animated: true)
           
        if editing == false {
            deleteButton.isEnabled = false
            
         }
        }
  
    // select to toggle checkmark
    
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        if tableView.isEditing {
             
            deleteButton.isEnabled = true
            return   //  not to intercept between didselectrow and editing
        }
        
         let item = items[indexPath.row]
        
          item.done = !(item.done)
           
          saveItems()
 
        }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           
          if tableView.isEditing && tableView.indexPathsForSelectedRows == nil {
            deleteButton.isEnabled = false
          }
          
        }
    
    //swipe to delete
    
      override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
          let item = items[indexPath.row]
          let indexPaths = [indexPath]

          context.delete(item)
          saveItems()
          items.remove(at: indexPath.row)
          tableView.deleteRows(at: indexPaths, with: .automatic)
             
        }
    
   // MARK: - Delegate Methods
    
    func configureText(for cell: UITableViewCell, with item: todoItem){
           
          if let editingCell = cell as? ToDoListTableViewCell {
              editingCell.name.text = item.name
                
              saveItems()
           }
      }
    
        // if segue happens to edit view
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             
             if segue.identifier == "EditItemSegue"  {
               if let editItemViewController = segue.destination as? DetailTableViewController {
                  if let cell = sender as? UITableViewCell,
                      let indexPath = tableView.indexPath(for: cell)
                   {
                      let item = items[indexPath.row]
                    editItemViewController.ToDoItem = item
                     editItemViewController.delegate = self
                    
                    }
                 }
              }
          }
     
     }
    
extension ToDoListViewController: DetailTableViewControllerDelegate {
    
    func DetailTableViewController(controller: DetailTableViewController, didFinishEditing item: todoItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
             if let cell = tableView.cellForRow(at: indexPath) {
             configureText(for: cell, with: item)
                
                }
          }
         
        navigationController?.popViewController(animated: true)

    }
    
    
    func DetailTableViewControllerDidCancel(controller: DetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }
     
   
}

 
