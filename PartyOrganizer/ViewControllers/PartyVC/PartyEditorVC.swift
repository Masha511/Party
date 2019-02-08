//
//  PartyEditorVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartyEditorVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func saveParty(_ sender: Any)
    {
        let party = Party(name: "Party\(User.shared.parties.count)", description: "Malo duzi opis", date: Date())
        if let index = User.shared.currentPartyIndex
        {
            User.shared.parties[index] = party
        }
        else
        {
            User.shared.parties.append(party)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
