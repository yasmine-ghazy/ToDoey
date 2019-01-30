//
//  Item.swift
//  ToDoey
//
//  Created by Hesham Khaked on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import Foundation

class Item:  Codable{
    var title: String = ""
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
