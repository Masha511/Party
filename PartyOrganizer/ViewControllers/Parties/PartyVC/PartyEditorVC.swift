//
//  PartyEditorVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit
import UserNotifications

class PartyEditorVC: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, PartyCellDelegate
{
    @IBOutlet weak var contentBottom_c: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var membersTableView: UITableView!
    
    @IBOutlet weak var descriptionHolderHeight_c: NSLayoutConstraint!
    @IBOutlet weak var countDownLbl: UILabel!
    var party: Party!
    @IBOutlet weak var countDownLblHeigh_c: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        descriptionTextView.delegate = self
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        
        self.countDownLbl.adjustsFontSizeToFitWidth = true
    }
    
    deinit
    {
        self.timer?.invalidate()
        self.timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if let party = self.party
        {
            self.placeholderLbl.isHidden = !party.desc.isEmpty
        }
        else
        {
            self.placeholderLbl.isHidden = false
        }
        self.detailsTableView.reloadData()
        self.membersTableView.reloadData()
        self.setupCountdownVisibility()
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
    
    //MARK: -Countdown
    private var isCountdownShown = false
    private func setupCountdownVisibility()
    {
        if let party = self.party,
        let partyDate = party.date
        {
            let today = Date()
            if today.compare(partyDate) == .orderedAscending
            {
                showCountdow(for: partyDate)
            }
            else
            {
                hideCountdown()
            }
        }
        else
        {
            hideCountdown()
        }
    }
    
    private func showCountdow(for date: Date)
    {
        isCountdownShown = true
        self.countDownLblHeigh_c.constant = 80.0
        self.descriptionHolderHeight_c.constant = -80.0
        self.view.layoutIfNeeded()
        
        self.startCountDown(for: date)
    }
    
    private func hideCountdown()
    {
        isCountdownShown = false
        self.timer?.invalidate()
        self.timer = nil
        self.countDownLblHeigh_c.constant = 0.0
        self.descriptionHolderHeight_c.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
    private var timer: Timer?
    private func startCountDown(for date: Date)
    {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.updateTime(to: date)
        })
    }
    
    private func updateTime(to date: Date)
    {
        let interval = date.timeIntervalSince(Date())
        countDownLbl.text = interval.getString()
    }
    
    //MARK: -Party Detail Cell Delegate
    func didUpdateName(_ name: String?, cell: PartyDetailCell)
    {
        self.party.name = name ?? ""
    }
    
    func didUpdateDate(_ date: Date?, cell: PartyDetailCell)
    {
        self.party.date = date
        if let cell = detailsTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? PartyReminderCell
        {
            if date == nil || date!.compare(Date()) == .orderedAscending
            {
                cell.disableSwitch()
                self.party.isReminderOn = false
            }
            else
            {
                cell.enableSwitch()
            }
        }
    }
    
    func didUpdateReminder(_ isOn: Bool, cell: PartyReminderCell)
    {
        if isOn
        {
            checkNotifications()
        }
        else
        {
            party.isReminderOn = false
        }
    }
    
    private func checkNotifications()
    {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            
            if settings.authorizationStatus == .notDetermined
            {
                center.requestAuthorization(options: UNAuthorizationOptions(arrayLiteral: .alert, .sound)) { (authorized, error) in
                    
                    if authorized
                    {
                        self.party.isReminderOn = true
                    }
                }
            }
            else if settings.authorizationStatus == .authorized
            {
                self.party.isReminderOn = true
            }
            else
            {
                let alert = UIAlertController(title: "Not authorized", message: "This application is not authorized to send notifications.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: -TextView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        placeholderLbl.isHidden = true
        
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        placeholderLbl.isHidden = !textView.text.isEmpty
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
                self.contentBottom_c.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom - (isCountdownShown ? 80.0 : 0.0)
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
        return 4
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
        else if indexPath.row == 2
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
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PartyReminderCell") as! PartyReminderCell
            
            if party.date == nil || party.date!.compare(Date()) == .orderedAscending
            {
                cell.disableSwitch()
            }
            else
            {
                cell.enableSwitch()
                cell.setSwitch(on: party.isReminderOn)
            }
            cell.delegate = self
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
        
        if party.isReminderOn
        {
            party.scheduleNotification()
        }
        else
        {
            party.cancelNotification()
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
