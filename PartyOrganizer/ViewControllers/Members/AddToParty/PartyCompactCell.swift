//
//  PartyCompactCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartyCompactCell: UITableViewCell
{
    var isPartySelected = false
    {
        didSet
        {
            if isPartySelected
            {
                self.accessoryType = .checkmark
            }
            else
            {
                self.accessoryType = .none
            }
        }
    }

    func set(name: String)
    {
        self.textLabel?.text = name
    }
}
