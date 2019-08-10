//
//  NotesViewController.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class NotesViewController: SwipeTableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!

  
  //Initialize a new access point to the Realm database
  let realm = try! Realm()
  
  // Create a variable that is a collection of results that are Folder objects
  var notesList : Results<Note>?
  
  var selectedFolder : Folder? {
    didSet {
      loadNotes()
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    //  This next line prints the location of the Realm database when un-commented out
    // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    tableView.separatorStyle = .none

  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    // Set the title of the chosen folder for the Notes Title Bar
    title = selectedFolder?.name
    
    // Set the color of the note list Title Bar to match the chosen folder
    guard let colorHex = selectedFolder?.cellBGColor else { fatalError() }
    
    updateNavBar(withHexCode: colorHex)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    updateNavBar(withHexCode: "1D9BF6")
    
  }
  
  
  //MARK: - Nav Bar Setup Methods
  
  func updateNavBar(withHexCode colorHexCode: String) {
    
    // Check to see if there already is a Nav Bar
    guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
    
    guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
    
    navBar.barTintColor = navBarColor
    
    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
    
    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    
    searchBar.barTintColor = navBarColor
  }

  
  //MARK: - Tableview Datasource Methods

  //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notesList?.count ?? 1
  }
  
  
  //TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let note = notesList?[indexPath.row] {
      
      cell.textLabel?.text = note.title
      
      if let bgColor = UIColor(hexString: selectedFolder!.cellBGColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(notesList!.count)) {
        cell.backgroundColor = bgColor
        cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true) // sets text to contrast the background color
      }
      
      //      print("version 1: \(CGFloat(indexPath.row / notesList!.count))")
      //      print("version 2: \(CGFloat(indexPath.row) / CGFloat(notesList!.count))")
      
      // Ternary operator ==>
      // value = condition ? valueIfTrue : valueIfFalse
      cell.accessoryType = note.done ? .checkmark : .none
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
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      }
    }
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
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
      
      // Call all the Tableview Datasource methods
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
  
  
  //MARK: - Model Manipulation Methods
  
  func loadNotes() {
    
    notesList = selectedFolder?.notes.sorted(byKeyPath: "title", ascending: true)
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
  }
  
  override func updateModel(at indexPath: IndexPath) {
    if let item = notesList?[indexPath.row] {
      do {
        try realm.write {
          realm.delete(item)
        }
      } catch {
        print("Error deleting item, \(error)")
      }
    }
  }
}

//MARK: - Search bar methods

extension NotesViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    notesList = notesList?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
    
    // Call all the Tableview Datasource methods
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
