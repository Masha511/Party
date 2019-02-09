//
//  PartyMemberCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartyMemberCell: UITableViewCell
{
    func set(name: String)
    {
        self.textLabel?.text = name
    }
}
