//
//  Party.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit
import UserNotifications

class Party: NSObject, NSCoding
{
    var name = ""
    var date: Date!
    var desc = ""
    var members = [Member]()
    var isReminderOn = false
    
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
    
    //MARK: -Notifications
    private var notificationID = ""
    
    func scheduleNotification()
    {
        cancelNotification()
        self.notificationID = self.name + Date().getDateIDString() //to get unique ID for notification
        
        let content = UNMutableNotificationContent()
        content.title = "Party is starting"
        content.body = self.name + " is starting right now!"
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: self.notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelNotification()
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.notificationID])
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
        self.isReminderOn = aDecoder.decodeBool(forKey: "isReminderOn")
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(members, forKey: "members")
        aCoder.encode(isReminderOn, forKey: "isReminderOn")
    }
}
