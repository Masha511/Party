//
//  PartiesVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var partiesTableView: UITableView!
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10.0
        
        let backBarButton = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if User.shared.parties.count == 0
        {
            partiesTableView.isHidden = true
        }
        else
        {
            partiesTableView.isHidden = false
            self.partiesTableView.reloadData()
        }
    }
    
    //MARK: -Table View Data Source & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.shared.parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCell") as! PartyCell
        cell.set(party: User.shared.parties[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "PartyEditorSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            User.shared.parties.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: -Actions
    @IBAction func addParty(_ sender: Any)
    {
        self.performSegue(withIdentifier: "PartyEditorSegue", sender: nil)
    }
    
    
}
