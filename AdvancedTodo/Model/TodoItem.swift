//
//  TodoItem.swift
//  AdvancedTodo
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class TodoItem {
    var text: String
    var checked: Bool
    
    init(textV: String, checkedV: Bool = false) {
        text = textV
        checked = checkedV
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    
}
