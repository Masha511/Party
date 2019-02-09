//
//  User.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding
{

    static var shared: User
    {
        if let data = UserDefaults.standard.object(forKey: "savedUser") as? Data,
            let user = try? NSKeyedUnarchiver.unarchiveObject(with: data) as? User
        {
            return user ?? User()
        }
        return User()
    }

    var parties = [Party]()
    {
        didSet
        {
            save()
        }
    }
    
    override init()
    {
        super.init()
    }
    
    func save()
    {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self) else {return}
        UserDefaults.standard.set(data, forKey: "savedUser")
        UserDefaults.standard.synchronize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        parties = aDecoder.decodeObject(forKey: "parties") as? [Party] ?? [Party]()
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(parties, forKey: "parties")
    }
}
