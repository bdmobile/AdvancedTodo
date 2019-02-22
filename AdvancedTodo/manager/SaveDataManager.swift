//
//  SaveDataManager.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class SaveDataManager {
    static var instance = SaveDataManager()
    
    static var documentDirectory: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)!
    static var dataFileUrl: URL = documentDirectory.appendingPathComponent("ItemList").appendingPathExtension("json")
    
    var lists: [Item] = []
    
    init() {
        NotificationCenter.default.addObserver( self,selector: #selector(self.saveListItem), name: UIApplication.didEnterBackgroundNotification, object: nil)
        loadListItem()
    }
    
    @objc func saveListItem() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(lists)
        try? data?.write(to: SaveDataManager.dataFileUrl)
    }
    
    func loadListItem() {
        if let data = try? Data(contentsOf: SaveDataManager.dataFileUrl),
            let list = try? JSONDecoder().decode([Item].self, from: data) {
            self.lists = list
        }
    }
    
}
