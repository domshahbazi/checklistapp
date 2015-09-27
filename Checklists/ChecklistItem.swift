//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Dom Shahbazi on 20/08/2015.
//  Copyright (c) 2015 Dom Shahbazi. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
}
