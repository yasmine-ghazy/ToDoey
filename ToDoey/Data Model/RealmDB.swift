//
//  RealmDB.swift
//  ToDoey
//
//  Created by Hesham Khaked on 2/4/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB{
    static let realm = try! Realm()
    
    static func getCategories() -> Results<Category>{
         return realm.objects(Category.self)
    }
    
    static func delete(object: Object){
        do{
            try! realm.write {
                realm.delete(object)
            }
        }catch{
            print("Error in deleting object")
        }
    }
    
    static func create(object: Object){
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error writing category! ", error)
        }
    }
}
