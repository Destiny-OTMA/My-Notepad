//
//  FolderViewController.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift

class FolderViewController: UITableViewController {
  
  //Initialize a new access point to the Realm database
  let realm = try! Realm()
  
  // Create a variable that is a collection of results that are Folder objects
  var folders: Results<Folder>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    loadFolders()
    
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of Folders as the NumberOfRowsInSection, if there are none, it returns 1
    return folders?.count ?? 1
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
    
    cell.textLabel?.text = folders?[indexPath.row].name ?? "No folders added yet"

    return cell
    
  }
  
  //MARK: - TableView Delegate Methods
  
  // This code will launch the goToNotes segue
  // The segue will open notes when a folder is chosen
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToNotes", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! NotesViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedFolder = folders?[indexPath.row]
    }
    
  }
  
  
  //MARK: - Data Manipulation Methods
  
  func save(folder: Folder) {

    do {
      try realm.write {
        realm.add(folder)
      }
    } catch {
      print("Error saving folder \(error)")
    }
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
  }
  
  
  func loadFolders() {
    
    folders = realm.objects(Folder.self)

    // Call all the Tableview Datasource methods
    tableView.reloadData()

  }
  
  
  //MARK: - Add New Folders (was Categories)
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Folder", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      // what will happen when the add button is pressed?
      
      let newFolder = Folder()
      newFolder.name = textField.text!

      self.save(folder: newFolder)
      
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Add a new folder"
      
    }
    
    present(alert, animated: true, completion: nil)
    
  }
  
}
