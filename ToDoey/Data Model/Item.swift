//
//  Item.swift
//  ToDoey
//
//  Created by Hesham Khaked on 2/4/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createDate: Date?
    
    /**
     In realm the inverse relationship doesn't created automatically.
     LinkingObjects: LinkingObjects is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship.
     fromType: Object.type -> class.self
     property: forward relationship property
     */
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
