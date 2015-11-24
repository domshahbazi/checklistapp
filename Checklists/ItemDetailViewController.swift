//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Dom Shahbazi on 20/08/2015.
//  Copyright (c) 2015 Dom Shahbazi. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    var dueDate = NSDate()
    
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
        
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    // Dont grey out the row when selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    // Auto open keyboard when screen is opened
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
        
            var cell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell")
        
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell!.selectionStyle = .None
                
                // 3
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0,
                width: 320, height: 216))
                datePicker.tag = 100
                cell!.contentView.addSubview(datePicker)
                
                // 4
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
        
            return cell!
        
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
   
    }
        
    
    
    
    
}
