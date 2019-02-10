//
//  PartyDetailCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

protocol PartyDetailCellDelegate: class
{
    func didUpdateName(_ name: String?, cell: PartyDetailCell)
    func didUpdateDate(_ date: Date?, cell: PartyDetailCell)
}

class PartyDetailCell: UITableViewCell, UITextFieldDelegate
{
    @IBOutlet weak var textField: UITextField!
    weak var delegate: PartyDetailCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        textField?.delegate = self
        textField?.returnKeyType = .done
        textField?.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        if self.reuseIdentifier == "PartyDateCell"
        {
            self.setDatePickerInput()
        }
        else if self.reuseIdentifier == "PartyNameCell"
        {
            self.textField.inputView = nil
            self.textField?.inputAccessoryView = nil
        }
    }
    
    func set(detail: String)
    {
        if self.reuseIdentifier == "PartyMembersCell"
        {
            self.textLabel?.text = "Members" + (detail.isEmpty ? "" : "(\(detail))")
            return
        }
        
        self.textField.text = detail.isEmpty ? nil : detail
    }
    
    func startEditing()
    {
        self.textField?.becomeFirstResponder()
    }
    
    //MARK: Date Picker
    
    func setDatePickerInput()
    {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        self.textField?.inputView = datePicker
        
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))]
        toolbar.sizeToFit()
        self.textField?.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ picker: UIDatePicker)
    {
        self.textField?.text = picker.date.getString(withTime: true)
        updateValues(from: textField)
    }
    
    @objc func done()
    {
        if let picker = self.textField.inputView as? UIDatePicker
        {
            self.textField?.text = picker.date.getString(withTime: true)
            self.updateValues(from: self.textField)
        }
        
        self.textField?.resignFirstResponder()
    }

    //MARK: -Text Field
    @objc func textFieldChanged(_ textField: UITextField)
    {
        updateValues(from: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        updateValues(from: textField)
        textField.resignFirstResponder()
        return true
    }
    
    private func updateValues(from textField: UITextField)
    {
        if self.reuseIdentifier == "PartyNameCell"
        {
            delegate?.didUpdateName(textField.text, cell: self)
        }
        else if self.reuseIdentifier == "PartyDateCell"
        {
            guard let string = self.textField?.text else {return}
            
            delegate?.didUpdateDate(string.getDate(withTime: true), cell: self)
        }
    }
}
