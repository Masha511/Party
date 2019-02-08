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
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func set(party: Party)
    {
        self.titleLbl.text = party.name + "\n" + party.date.getString(withTime: false)
        self.detailLbl.text = party.desc
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
