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
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: -Actions
    @IBAction func addParty(_ sender: Any)
    {
        self.performSegue(withIdentifier: "PartyEditorSegue", sender: nil)
    }
    
    
}
