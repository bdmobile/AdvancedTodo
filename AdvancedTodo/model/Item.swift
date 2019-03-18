//
//  Item.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

//import Foundation
//
//
//class Item: Codable {
//    var name: String
//    var check: Bool
//
//    init(name: String, check:Bool = false) {
//        self.name = name
//        self.check = check
//    }
//
//    func toggleCheck() {
//        self.check = !check
//    }
//}


extension Item {
    func toggleCheck() {
        self.check = !check
    }
}
