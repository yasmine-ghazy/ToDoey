//
//  Data.swift
//  ToDoey
//
//  Created by Hesham Khaked on 2/4/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import Foundation
import RealmSwift

//Object is a class used to define Realm model objects
class Category: Object{
    /**
     Dynamic is a declaration modifier it basically tells the runtime to use dynamic dispatch over standard
     which is a static dispatch.
     And this basically allows the property to be monitored for change at runtime
     I.e while the app is running so that mean if the user changes the value of name while the app is running
     then that allows realm to dynamically update those changes in the db.
     but dynamic dispatch is actually something comes from the Objective-C API
     So we must mark dynamic with @Objc to explicit that we are using obj-c at runtime
     */
    @objc dynamic var name: String = ""
    
    /**
     Here we define a forward relationship.
     inside each category there is a thing called items that is going to point to a list of item objects
     */
    let items = List<Item>()
}
