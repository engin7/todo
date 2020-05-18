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
    
     private var items = [Items]()
    
    
    @IBAction func addItem(_ sender: Any) {
        
      var textField = UITextField()

      let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Save", style: .default) { (action) in
        
          let newItem = Items(context: self.context)
          newItem.name = textField.text!
          newItem.done = false
          newItem.notes = ""
          self.items.append(newItem)
          self.saveItems()

      }
      
      alert.addTextField { (alertTextField) in
          alertTextField.placeholder = "Create New Item"
          textField = alertTextField
          
      }
      
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

                tableView.beginUpdates()
                tableView.deleteRows(at: selectedRows, with: .automatic)
                tableView.endUpdates()
             }
                 saveItems()
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchItems()
       }
    
    
    //MARK - CoreData Methods
    
    
    // fetch from CoreData
    
        func fetchItems(){

         do {
           items = try context.fetch(Items.fetchRequest())
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
     
      
    //MARK - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ToDoListTableViewCell
        
        let item = items[indexPath.row]
        
        cell.name.text = item.name
        cell.check.isHighlighted = item.done

        return cell
    }
    
    //MARK - TableView Delegate Methods
       
    
    // enable editing mode:
    
       override func setEditing(_ editing: Bool, animated: Bool) {
           super.setEditing(editing, animated: true)
           tableView.setEditing(tableView.isEditing, animated: true)
        
        }
    
    // select to toggle checkmark
    
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        if tableView.isEditing {
            return   //  not to intercept between didselectrow and editing
        }
        
         let item = items[indexPath.row]
        
          item.done = !(item.done)
           
          saveItems()
 
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
    
   //MARK - Delegate Methods
    
    func configureText(for cell: UITableViewCell, with item: Items){
           
          if let editingCell = cell as? ToDoListTableViewCell {
              editingCell.name.text = item.name
                
              saveItems()
           }
      }
    
        // if segue happens to edit view
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             
             if segue.identifier == "EditItemSegue"  {
               if let editItemViewController = segue.destination as? TodoItemDetailTableViewController {
                  if let cell = sender as? UITableViewCell,
                      let indexPath = tableView.indexPath(for: cell)
                   {
                      let item = items[indexPath.row]
                    editItemViewController.todoItem = item
                     editItemViewController.delegate = self
                    
                    }
                 }
              }
          }
     }
    
extension ToDoListViewController: TodoItemDetailTableViewControllerDelegate {
    
    func TodoItemDetailTableViewController(controller: TodoItemDetailTableViewController, didFinishEditing item: Items) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
             if let cell = tableView.cellForRow(at: indexPath) {
             configureText(for: cell, with: item)
                
                }
          }
         
        navigationController?.popViewController(animated: true)

    }
    
    
    func TodoItemDetailTableViewControllerDidCancel(controller: TodoItemDetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }
     
   
}

 
