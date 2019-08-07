//
//  Folder.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/31/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import Foundation
import RealmSwift

class Folder: Object {
  // Create a new property
  @objc dynamic var name : String = ""
  @objc dynamic var cellBGColor : String = ""
  // define a forward relationship
  let notes = List<Note>()
}

