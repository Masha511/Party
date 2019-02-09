//
//  String+.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import Foundation

extension String
{
    func getDate(withTime: Bool)-> Date?
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
        return formatter.date(from: self)
    }
}
