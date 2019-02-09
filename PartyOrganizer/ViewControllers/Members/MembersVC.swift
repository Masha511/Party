//
//  MembersVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class MembersVC: UITableViewController
{
    private var members = [Member]()
    private var selectedMembers = [Member]()
    var isPreviewMembers = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        
        Member.loadMembers { (members) in
            self.members = members
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        prepareScreen()
    }
    
    var party: Party?
    func present(for party: Party)
    {
        isPreviewMembers = true
        self.party = party
        self.selectedMembers.append(contentsOf: party.members)
    }
    
    private func prepareScreen()
    {
        if isPreviewMembers
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
            self.tableView.allowsMultipleSelection = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil
            self.tableView.allowsMultipleSelection = false
        }
    }
    
    @objc func save(_ sender: UIBarButtonItem)
    {
        self.party?.members = self.selectedMembers
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        cell.set(member: members[indexPath.row], forSelection: isPreviewMembers)
        if isPreviewMembers
        {
            cell.setSelected(self.selectedMembers.contains(members[indexPath.row]), animated: false)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isPreviewMembers
        {
            self.selectedMembers.append(members[indexPath.row])
        }
        else
        {
            //TODO: view profile
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if isPreviewMembers
        {
            if let index = self.selectedMembers.index(of: members[indexPath.row])
            {
                self.selectedMembers.remove(at: index)
            }
        }
    }
}
