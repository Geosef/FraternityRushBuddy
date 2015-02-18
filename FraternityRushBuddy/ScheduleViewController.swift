//
//  ScheduleViewController.swift
//  FraternityRushBuddy
//
//  Created by Joseph Carroll on 2/3/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import UIKit
import EventKit

class ScheduleViewController: UIViewController, CVCalendarViewDelegate {
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    var shouldShowDaysOut = true
    var animationFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthLabel.text = CVDate(date: NSDate()).description()
        
        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            insertEvent(eventStore)
        case .Denied:
            println("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        self!.insertEvent(eventStore)
                    } else {
                        println("Access denied")
                    }
            })
        default:
            println("Case Default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendarsForEntityType(EKEntityTypeEvent)
            as [EKCalendar]
        
        for calendar in calendars {
            // 2
            if calendar.title == "testcal" {
                // 3
                let startDate = NSDate()
                // 2 hours
                let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
                
                // 4
                // Create Event
                var event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                
                // 5
                // Save Event in Calendar
                var error: NSError?
                let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
                
                if result == false {
                    if let theError = error {
                        println("An error occured \(theError)")
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calendarView.commitCalendarViewUpdate()
        self.calendarView!.changeDaysOutShowingState(false)
        self.shouldShowDaysOut = true
        self.menuView.commitMenuViewUpdate()
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Calendar View Delegate
    
    func shouldShowWeekdaysOut() -> Bool {
        return self.shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        // TODO:
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor { 
        if dayView.date?.week == 3 {
            return .redColor()
        } else if dayView.date?.day == 5 {
            return .blackColor()
        } else if dayView.date?.day == 2 {
            return .blueColor()
        }
        
        return .greenColor()
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        if dayView.date?.day == 3 || dayView.date?.day == 5 || dayView.date?.day == 2 {
            return true
        } else {
            return false
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func presentedDateUpdated(date: CVDate) {
        if self.monthLabel.text != date.description() && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.description
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { (finished) -> Void in
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = CVCalendarManager.sharedManager
        let components = calendarManager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleMonthViewWithDate(resultDate)
    }
    
    
}
