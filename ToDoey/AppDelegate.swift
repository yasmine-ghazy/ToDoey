//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Yasmine Ghazy on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        do{
            _ = try Realm()
        }catch{
            print("Error initializing new realm")
        }
        
        //Location of realm db
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }
}

