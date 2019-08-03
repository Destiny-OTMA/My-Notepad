//
//  NotesViewController.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {
      @IBOutlet weak var myTextField: UITextField!

  var notesList : Results<Note>?
  let realm = try! Realm()

  var selectedFolder : Folder? {
    didSet {
      loadNotes()
      
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

  
    // MARK: - Tableview Datasource Methods

    //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notesList?.count ?? 1
  }

  //TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
    
    if let note = notesList?[indexPath.row] {
      
      cell.textLabel?.text = note.title
    } else {
      cell.textLabel?.text = "No Notes Added"
      
    }
    
    
    return cell
  }

  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if let item = notesList?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(item)
        }
      } catch {
        print("Error deleting the note, \(error)")
      }
    }

//    tableView.reloadData()

    tableView.deselectRow(at: indexPath, animated: true)

  }

  
  //MARK: - Add a new note to the list

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Note button on our UIAlert
      
      if let currentFolder = self.selectedFolder {
        do {
          try self.realm.write {
            let newNote = Note()
            newNote.title = textField.text!
            newNote.dateCreated = Date() // records current date/time when item is created
            currentFolder.notes.append(newNote)
          }
        } catch {
          print("Error saving new notes, \(error)")
        }
      }

      self.tableView.reloadData()
      
    }
  
    // add a text field to the pop up alert
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new note"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)

  }

  
  //MARK: - Delete a note from the list
  
  @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
    
    // Declare Alert Message
    let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this note?", preferredStyle: .alert)

    // Create OK button with action handler
    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
      print("OK button was pressed")
      self.tableView.reloadData()
    })
    
    //Create CANCEL button with acton handler
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
      print("You pressed Cancel")
    }
    
    // Add OK and Cancel buttons to dialog box
    
    dialogMessage.addAction(ok)
    dialogMessage.addAction(cancel)

    // Present dialog box to user
    self.present(dialogMessage, animated: true, completion: nil)
    
  }
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  //MARK: - Model Manipulation Methods

  func loadNotes() {
    
    notesList = selectedFolder?.notes.sorted(byKeyPath: "title", ascending: true)

    tableView.reloadData()
  }
  
}

//MARK: - Search bar methods

extension NotesViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    notesList = notesList?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
    
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
