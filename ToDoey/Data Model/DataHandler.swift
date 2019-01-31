//
//  DataHandler.swift
//  ToDoey
//
//  Created by Hesham Khaked on 1/28/19.
//  Copyright © 2019 Yasmine Ghazy. All rights reserved.
//

import Foundation
import UIKit

class DataHandler{
    
    static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    /**
     This method save items to P-List.
     - Parameter items: A list of items to be saved.
     */
    static func saveItems(items: [Item]){
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array! ", error)
        }
        
    }
    
    /**
     This method load items from P-List.
     */
    static func loadItems() -> [Item]{
        var items = [Item]()
        
        do{
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                items = try decoder.decode([Item].self, from: data)
            }
        } catch{
            print("Error decoding item array! ", error)
        }
        
        return items
    }
    
}

