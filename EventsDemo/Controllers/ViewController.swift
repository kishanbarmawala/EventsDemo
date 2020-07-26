//
//  ViewController.swift
//  EventsDemo
//
//  Created by Kishan Barmawala on 17/07/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit
import JKCalendar

class ViewController: UIViewController {

    // MARK: - IBOUTLETS
    
    @IBOutlet weak var jkCalender: JKCalendar!
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    
    // MARK: - DECLARATIONS
    
    var selectedDate : JKDay?
    var arrEvents = [EventsModel]()
    
    // MARK: - VIEW_METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = DatabaseAccess()
        
        jkCalender.delegate = self
        jkCalender.dataSource = self
        
        tblData.register(UITableViewCell.self, forCellReuseIdentifier: "EventsTVCell")
        
        selectedDate = JKDay(date: Date())
        
        refreshView()
        
    }
    
    // MARK: - FUNCTIONS
    
    func showAlert(_ message: String, callBack: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: { callBack?() })
        }
        
    }
    
    func refreshView() {
        if db!.EventExists(selectedDate!.date.toString()) {
            fieldView.isHidden = true
            tblData.isHidden = false
            arrEvents = db!.GetEventsData(selectedDate!.date.toString())
            tblData.reloadData()
        }
        else {
            fieldView.isHidden = false
            tblData.isHidden = true
        }
        txtDesc.text = ""
        txtEventName.text = ""
    }

    // MARK: - BUTTON_ACTIONS
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if txtEventName.text!.isEmpty {
            showAlert("Please Enter Event Name")
        }
        else if txtEventName.text!.isEmpty {
            showAlert("Please Enter Event Description")
        }
        else {
            if db!.InsertEventData(selectedDate!.date.toString(), txtEventName.text!, txtDesc.text!) {
                showAlert("Event Created!", callBack: { [unowned self] in
                    self.refreshView()
                })
            }
            else {
                showAlert("Getting Error while creating Event...")
            }
        }
    }
    
}

// MARK: - EXTENSIONS_CALENDER

extension ViewController: JKCalendarDelegate, JKCalendarDataSource {
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {
        let today = JKDay(date: Date())
        var selected = JKDay(date: Date())
        if let newSelected = selectedDate {
            selected = newSelected
        }
        if today == month {
            return [JKCalendarMark(type: .circle, day: selected, color: UIColor.red),JKCalendarMark(type: .underline, day: today, color: UIColor.red)]
        }
        else {
            return nil
        }
    }
    
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay) {
        selectedDate = day
        calendar.reloadData()
        refreshView()
    }
    
    
    
}

// MARK: - EXTENSIONS_TABLEVIEW

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: "EventsTVCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel!.text = "Date : \(arrEvents[indexPath.row].eventDate)\nName : \(arrEvents[indexPath.row].eventName)\nDesc : \(arrEvents[indexPath.row].eventDesc)"
        return cell
    }
}

// MARK: - SUPPORTING_EXTENSIONS

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: self)!
    }
}
