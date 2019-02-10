//
//  Date+.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import Foundation

extension Date
{
    func getString(withTime: Bool)-> String
    {
        let formatter = DateFormatter()
        if withTime
        {
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
        }
        else
        {
            formatter.dateFormat = "dd.MM.yyyy"
        }
        return formatter.string(from: self) 
    }
}
