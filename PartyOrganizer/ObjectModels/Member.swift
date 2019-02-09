//
//  Member.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

let json_url = URL(string: "http://api-coin.quantox.tech/profiles.json")

enum Gender: String
{
    case male
    case female
}

class Member: NSObject
{
    private static var _all = [Member]()
    
    class func loadMembers(completionHandler: @escaping (_ members: [Member]) -> Void)
    {
        guard Member._all.count == 0,
        let url = json_url else
        {
            completionHandler(Member._all)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil
            {
                print(error?.localizedDescription ?? "Error")
                completionHandler(Member._all)
                return
            }
            
            if let data = data,
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let profiles = jsonObj?.value(forKey: "profiles") as? NSArray
            {
                for i in 0 ..< profiles.count
                {
                    if let profileDict = profiles[i] as? NSDictionary
                    {
                        let member = Member()
                        let valueID = (profileDict["id"] as? String) ?? ""
                        member.id = Int(valueID) ?? -1
                        
                        member.name = (profileDict["username"] as? String) ?? ""
                        member.cell = (profileDict["cell"] as? String) ?? ""
                        member.photo = (profileDict["photo"] as? String) ?? ""
                        member.email = (profileDict["email"] as? String) ?? ""
                        
                        let valueGender = (profileDict["gender"] as? String) ?? ""
                        member.gender = Gender(rawValue: valueGender) ?? .male
                        
                        member.aboutMe = (profileDict["aboutMe"] as? String) ?? ""
                        
                        Member._all.append(member)
                        
                        if i == profiles.count - 1
                        {
                            completionHandler(Member._all)
                        }
                    }
                }
            }
            else
            {
                completionHandler(Member._all)
            }
        }
    }
    
    var id = -1
    var name = ""
    var gender = Gender.male
    var email = ""
    var aboutMe = ""
    var cell = ""
    var photo = ""
}
