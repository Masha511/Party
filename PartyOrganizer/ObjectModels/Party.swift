//
//  Party.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class Party: NSObject
{
    var name = ""
    var date: Date!
    var desc = ""
    
    convenience init(name: String, description: String, date: Date)
    {
        self.init()
        self.name = name
        self.desc = description
        self.date = date
    }
}
