//
//  PartyCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartyCell: UITableViewCell
{
    @IBOutlet weak var partNameLbl: UILabel!
    @IBOutlet weak var partyDateLbl: UILabel!
    @IBOutlet weak var partyDescriptionLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func set(party: Party)
    {
        partNameLbl.text = party.name
        partyDateLbl.text = party.date.getString(withTime: false)
        partyDescriptionLbl.text = party.desc.isEmpty ? "No description available" : party.desc
    }
}
