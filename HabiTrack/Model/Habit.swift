//
//  Habit.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/31/19.
//  Copyright © 2021 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData


// name: Habit
// desc: habit class
// last updated: 3/28/2021
// last update: refactored from 'Habits' to 'Habit'
@objc(Habit)
public class Habit:NSManagedObject {

    struct Name {
        static let startDate = "startDate"
        static let repeatDays = "repeatDays"
    }
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var tintColor: UIColor?
    @NSManaged public var uuid: UUID?
    @NSManaged public var streak: NSDecimalNumber?
    
    // Let Core Data generate accessors for primitiveRepeatDays and primitiveStartDate,
    // which are used in the custom accessors for repeatDays and startDate.
    //
    @NSManaged private var primitiveStartDate: Date?
    @NSManaged private var primitiveRepeatDays: String?

    // This sets up the key path dependency for repeatDays,
    // allowing the observers of repeatDays to get notified when its date changes.
    //
    class func keyPathsForValuesAffectingPublishMonthID() -> Set<String> {
        return [Name.startDate]
    }

    // Provide a custom accessor to nullify primitiveRepeatDays so it is recalculated next time it is used.
    // Date is equivalent to TimeInterval, or Double; it is really a number of seconds since 1970.
    //
    @objc public var startDate: Date? {
        get {
            willAccessValue(forKey: Name.startDate)
            defer { didAccessValue(forKey: Name.startDate) }
            return primitiveStartDate
        }
        set {
            willChangeValue(forKey: Name.startDate)
            defer { didChangeValue(forKey: Name.startDate) }
            primitiveStartDate = newValue
            primitiveRepeatDays = nil
        }
    }

    // Provide a custom accessor for publishMonthID.
    // @objc is required as this property is used as a key path in NSFetchedResultsController.
    // Use .gregorian calendar to make sure the formula (year * 1000 + month) is valid.
    //
    // Encode the year and month components to a string then decode and convert it to a section title because:
    // 1. publishMonthID is used in NSFetchedResultsController's sectionNameKeyPath, which requires the sections are
    //    sorted in the same order as the rows so they can be fetched in batch.
    // 2. TableView section title is a user-visible string from the year + month and changes based on the current
    //    system settings (calendar, locale, time zone), so we can't convert year + month directly to a title string.
    //
    @objc public var repeatDays: String? {
        willAccessValue(forKey: Name.repeatDays)
        defer { didAccessValue(forKey: Name.repeatDays) }
        
        guard primitiveRepeatDays == nil, let date = primitiveStartDate else {
            return primitiveRepeatDays
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: date)
        if let year = components.year, let month = components.month {
            primitiveRepeatDays = "\(year * 1000 + month)"
        }
        return primitiveRepeatDays
    }

    // Convert a publishMonthString, or the section name of the main table view, to a date.
    // Use the same calendar and time zone to decode the transient value.
    //
    class func date(from publishMonthString: String) -> Date? {
    
        guard let numericSection = Int(publishMonthString) else {
            return nil
        }
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)

        let year = numericSection / 1000
        let month = numericSection - year * 1000
        dateComponents.year = year
        dateComponents.month = month
        
        return dateComponents.calendar?.date(from: dateComponents)
    }
} // end class
