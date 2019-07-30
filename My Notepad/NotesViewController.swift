//
//  NotesViewController.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {

  var notesArray = [Note]()

  var selectedFolder : Folder? {
    didSet {
      loadNotes()
      
    }
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

  
    // MARK: - Tableview Datasource Methods

    //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notesArray.count
  }

  //TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
    
    let note = notesArray[indexPath.row]
    
    cell.textLabel?.text = note.title
    
    // Ternary operator ==>
    // value = condition ? valueIfTrue : valueIfFalse
    // cell.accessoryType = Note.done ? .checkmark : .none
    
    return cell
  }

  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //TODO: Add/Remove a checkmark to/from the cell
    // if there is a checkmark already in the cell, toggle it off
    
    //        context.delete(itemArray[indexPath.row])
    //        itemArray.remove(at: indexPath.row)
    
    // notesArray[indexPath.row].done = !notesArray[indexPath.row].done
    
    saveNotes()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  
  //MARK: - Add New Item to the list

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button on our UIAlert
      
      let newNote = Note(context: self.context)
      newNote.title = textField.text!
//      newNote.done = false
      newNote.parentFolder = self.selectedFolder
      self.notesArray.append(newNote)
      
      self.saveNotes()
      
    }
  
    // add a text field to the pop up alert
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new note"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)

  }


  //MARK: - Model Manipulation Methods
  
  func saveNotes() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    self.tableView.reloadData()
  }
  
  
  func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let notePredicate = NSPredicate(format: "parentFolder.name MATCHES %@", selectedFolder!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [notePredicate, additionalPredicate])
    } else {
      request.predicate = notePredicate
    }
    
    do {
      notesArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    
    tableView.reloadData()
  }
  
}



















//MARK: - Search bar methods

extension NotesViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request : NSFetchRequest<Note> = Note.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadNotes(with: request, predicate: predicate)
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadNotes()
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
      
    }
    
  }
  
}
