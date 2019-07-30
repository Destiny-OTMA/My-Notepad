//
//  FolderViewController.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import CoreData

class FolderViewController: UITableViewController {
  
  var folderArray = [Folder]()
  
  
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadFolders()
    
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return folderArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
    
    cell.textLabel?.text = folderArray[indexPath.row].name
    
    return cell
    
  }
  
  //MARK: - TableView Delegate Methods
  
  // This code will launch the segue to open notes when a folder is chosen
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToNotes", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! NotesViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedFolder = folderArray[indexPath.row]
      
    }
    
  }
  
  
  
  //MARK: - Data Manipulation Methods
  
  func saveFolders() {
    do {
      try context.save()
    } catch {
      print("Error saving folder \(error)")
    }
    
    tableView.reloadData()
    
  }
  
  
  func loadFolders() {
    
    let request : NSFetchRequest<Folder> = Folder.fetchRequest()
    
    do {
      folderArray = try context.fetch(request)
    } catch {
      print("Error loading folders \(error)")
    }
    
    tableView.reloadData()
    
  }
  
  
  
  //MARK: - Add New Folders (was Categories)
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Folder", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      // what will happen when the add button is pressed?
      
      let newFolder = Folder(context: self.context)
      newFolder.name = textField.text!
      
      self.folderArray.append(newFolder)
      
      self.saveFolders()
      
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Add a new folder"
      
    }
    
    present(alert, animated: true, completion: nil)
    
  }
  
  
}
