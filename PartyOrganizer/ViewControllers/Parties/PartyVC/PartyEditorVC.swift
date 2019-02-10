//
//  PartyEditorVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

//TODO: Party CountDown

class PartyEditorVC: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, PartyDetailCellDelegate
{
    @IBOutlet weak var contentBottom_c: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var membersTableView: UITableView!
    
    var party: Party!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        descriptionTextView.delegate = self
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if let party = self.party
        {
            self.descriptionTextView.text = party.desc.isEmpty ? "No description available" : party.desc
        }
        else
        {
            self.descriptionTextView.text = ""
        }
        self.detailsTableView.reloadData()
        self.membersTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let membersVC = segue.destination as? MembersVC
        {
            membersVC.present(for: self.party)
        }
    }
    
    private var currentPartyIndex: Int? = nil
    {
        didSet
        {
            if currentPartyIndex == nil
            {
                self.party = Party()
            }
            else
            {
                self.party = User.shared.parties[currentPartyIndex!]
            }
        }
    }
    
    func present(forParty index: Int?)
    {
        self.currentPartyIndex = index
    }
    
    //MARK: -Party Detail Cell Delegate
    func didUpdateName(_ name: String?, cell: PartyDetailCell)
    {
        self.party.name = name ?? ""
    }
    
    func didUpdateDate(_ date: Date?, cell: PartyDetailCell)
    {
        self.party.date = date
    }
    
    //MARK: -TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    @objc func done(_ sender : UIBarButtonItem)
    {
        descriptionTextView.resignFirstResponder()
    }

    //MARK: -Keyboard Frame
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            if descriptionTextView.isFirstResponder
            {
                self.contentBottom_c.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
            }
            else
            {
                self.contentBottom_c.constant = 0.0
            }
            UIView.animate(withDuration: 0.2)
            {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        self.contentBottom_c.constant = 0.0
        UIView.animate(withDuration: 0.2)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: -TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == membersTableView
        {
            return party?.members.count ?? 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == membersTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartyMemberCell") as! PartyMemberCell
            cell.set(name: party!.members[indexPath.row].name)
            return cell
        }
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartyNameCell") as! PartyDetailCell
            cell.set(detail: party?.name ?? "")
            cell.delegate = self
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartyDateCell") as! PartyDetailCell
            cell.set(detail: party?.date?.getString(withTime: true) ?? "")
            cell.delegate = self
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartyMembersCell") as! PartyDetailCell
            if let party = self.party
            {
                cell.set(detail: "\(party.members.count)")
            }
            else
            {
                cell.set(detail: "")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return tableView == membersTableView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            party.members.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            detailsTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard tableView == detailsTableView else {return}
        if indexPath.row == 2
        {
            self.performSegue(withIdentifier: "PartyMembersPreviewSegue", sender: nil)
        }
    }

    //MARK: -Actions

    @IBAction func saveParty(_ sender: Any)
    {
        if party.name.isEmpty
        {
            let alert = UIAlertController(title: "No Name", message: "Please enter a name for this party.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                (self.detailsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PartyDetailCell)?.startEditing()
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if party.date == nil
        {
            let alert = UIAlertController(title: "No Date", message: "Please enter a date for this party.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                (self.detailsTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PartyDetailCell)?.startEditing()
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let index = self.currentPartyIndex
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
