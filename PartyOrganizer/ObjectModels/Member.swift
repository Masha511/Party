//
//  Member.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

let json_url = URL(string: "http://api-coin.quantox.tech/profiles.json")

class Member: NSObject, NSCoding
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

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil, data == nil
            {
                print(error?.localizedDescription ?? "Error")
                completionHandler(Member._all)
                return
            }

            if let data = data,
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let profiles = jsonObj?.value(forKey: "profiles") as? NSArray
            {
                var members = [Member]()
                for profile in profiles
                {
                    if let profileDict = profile as? NSDictionary
                    {
                        let member = Member()
                        member.id = (profileDict["id"] as? Int) ?? -1
                        member.name = (profileDict["username"] as? String) ?? ""
                        member.cell = (profileDict["cell"] as? String) ?? ""
                        member.photo = (profileDict["photo"] as? String) ?? ""
                        member.email = (profileDict["email"] as? String) ?? ""
                        member.gender = (profileDict["gender"] as? String) ?? ""
                        member.aboutMe = (profileDict["aboutMe"] as? String) ?? ""

                        members.append(member)
                    }

                    if members.count == profiles.count
                    {
                        Member._all = members
                        completionHandler(Member._all)
                    }
                }
            }
            else
            {
                completionHandler(Member._all)
            }
        }
        task.resume()
    }
    
    var id = -1
    var name = ""
    var gender = ""
    var email = ""
    var aboutMe = ""
    var cell = ""
    var photo = ""
    
    func loadImage(completionHandler: @escaping (UIImage?)-> Void)
    {
        guard let url = URL(string: self.photo) else
        {
            completionHandler(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else
            {
                completionHandler(nil)
                return
            }
            //save locally?
            completionHandler(UIImage(data: data))
        }
        task.resume()
    }
    
    override init()
    {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        gender = aDecoder.decodeObject(forKey: "gender") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as? String ?? ""
        cell = aDecoder.decodeObject(forKey: "cell") as? String ?? ""
        photo = aDecoder.decodeObject(forKey: "photo") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(cell, forKey: "cell")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(id, forKey: "id")
    }
}
