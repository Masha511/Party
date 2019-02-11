//
//  AddToPartyVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class AddToPartyVC: UITableViewController
{
    var selectedParties = [Int]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    private var member: Member!
    func present(for member: Member)
    {
        self.member = member
        self.navigationItem.title = member.name

        self.selectedParties = User.shared.parties.enumerated().compactMap({ (pair) -> Int? in
            if pair.element.members.contains(member)
            {
                return pair.offset
            }
            return nil
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.shared.parties.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCompactCell", for: indexPath) as! PartyCompactCell
        let party = User.shared.parties[indexPath.row]
        cell.isPartySelected = self.selectedParties.contains(indexPath.row)
        cell.set(name: party.name)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) as? PartyCompactCell
        {
            let party = User.shared.parties[indexPath.row]
            
            cell.isPartySelected = !cell.isPartySelected
            if cell.isPartySelected
            {
                self.selectedParties.append(indexPath.row)
                party.add(member: self.member)
            }
            else
            {
                if let index = self.selectedParties.index(of: indexPath.row)
                {
                    self.selectedParties.remove(at: index)
                    party.remove(member: member)
                }
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
