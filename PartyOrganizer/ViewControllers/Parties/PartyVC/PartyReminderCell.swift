//
//  PartyReminderCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/10/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit


class PartyReminderCell: UITableViewCell
{
    @IBOutlet weak var reminderSwitch: UISwitch!
    weak var delegate: PartyCellDelegate?
    
    func setSwitch(on: Bool)
    {
        reminderSwitch.isOn = on
    }
    
    func enableSwitch()
    {
        reminderSwitch.isEnabled = true
    }
    
    func disableSwitch()
    {
        reminderSwitch.isOn = false
        reminderSwitch.isEnabled = false
    }

    @IBAction func valueChanged(_ sender: UISwitch)
    {
        delegate?.didUpdateReminder(sender.isOn, cell: self)
    }
}
