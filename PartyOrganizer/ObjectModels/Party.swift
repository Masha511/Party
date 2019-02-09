//
//  Party.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class Party: NSObject, NSCoding
{
    var name = ""
    var date: Date!
    var desc = ""
    var members = [Member]()
    
    convenience init(name: String, description: String, date: Date)
    {
        self.init()
        self.name = name
        self.desc = description
        self.date = date
    }
    
    func add(member: Member)
    {
        if !self.members.contains(member)
        {
            self.members.append(member)
        }
    }
    
    func remove(member: Member)
    {
        if let index = members.index(of: member)
        {
            self.members.remove(at: index)
        }
    }
    
    override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        self.name = (aDecoder.decodeObject(forKey: "name") as? String) ?? ""
        self.desc = (aDecoder.decodeObject(forKey: "description") as? String) ?? ""
        self.date = (aDecoder.decodeObject(forKey: "date") as? Date) ?? Date()
        self.members = (aDecoder.decodeObject(forKey: "members") as? [Member]) ?? [Member]()
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(members, forKey: "members")
    }
}
