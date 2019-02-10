//
//  TimeInterval+.swift
//  PartyOrganizer
//
//  Created by Masha on 2/10/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import Foundation

extension TimeInterval
{
    func getString()-> String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter.string(from: self)
    }
}
