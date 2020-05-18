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
    
    
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    //MARK - CoreData Methods
    
    // fetch from CoreData
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         do {
           items = try context.fetch(Items.fetchRequest())
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
            tableView.reloadData()
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
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ToDoListTableViewCell
           
         let item = items[indexPath.row]
 
         cell.check.isHighlighted = item.done

          
        }
    

    
     
}

