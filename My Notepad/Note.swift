//
//  Note.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/31/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
  @objc dynamic var title : String = ""
  @objc dynamic var done : Bool = false
  @objc dynamic var dateCreated : Date?
  let items = List<Note>()
  var parentFolder = LinkingObjects(fromType: Folder.self, property: "notes")

}
