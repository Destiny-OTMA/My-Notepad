//
//  AppDelegate.swift
//  My Notepad
//
//  Created by Destiny Sopha on 7/25/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // to locate and print out where the Realm datafile is located
    // print(Realm.Configuration.defaultConfiguration.fileURL)
    
    do {
      _ = try Realm()
    } catch {
      print("Error initialising new realm, \(error)")
    }
    
    return true
  }
  
}

