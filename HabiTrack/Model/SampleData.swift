//
//  SampleData.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 3/28/21.
//  Copyright © 2021 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData

struct SampleData {
    
    // DateComponents() returns a DateComponents object with the current system time zone.
    // Use .gregorian and current time zone to set up date components and generate test data.
    // With a different calendar or time zone, a same set of date components will be mapped to a different date.
    //
    private static var dateComponents: DateComponents = {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2019
        return dateComponents
    }()
    
    static private func randomBookName(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÂĆĒĪÑØŚÜŸ"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    static private func generateOneNewBook(with dateComonents: DateComponents, context: NSManagedObjectContext) {
        let newHabit = Habit(context: context)
        
        // uuid: UUID
        //
        newHabit.uuid = UUID()
        
        if let day = dateComonents.day {
            newHabit.title = randomBookName(length: 10) + "-\(day)"
        }

        // startDate: Date
        //
        if let date = dateComonents.calendar?.date(from: dateComonents) {
            newHabit.startDate = date
        }
        
        // price: Use NSDecimalNumber to handle currency value
        //
        let value = UInt64(arc4random_uniform(9999))
        newHabit.streak = NSDecimalNumber(mantissa: value, exponent: -2, isNegative: false)

        // color: UIColor, transformable
        //
        let red = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let blue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        newHabit.tintColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func generateSampleDataIfNeeded(context: NSManagedObjectContext) {
        context.perform {
            print("generateSampleDataIfNeeded.Book.fetchRequest...")
            guard let number = try? context.count(for: Habit.fetchRequest()), number == 0 else {
                return
            }
            print("generateSampleDataIfNeeded.Book.fetchRequest...done")
            print("generateSampleDataIfNeeded.Book.generateOneNewBook...")
            for day in stride(from: 1, to: 365, by: 7) {
                dateComponents.day = day
                self.generateOneNewBook(with: dateComponents, context: context)
            }
            print("generateSampleDataIfNeeded.Book.generateOneNewBook...done")
            do {
                print("generateSampleDataIfNeeded.try context.save()...")
                try context.save()
                print("generateSampleDataIfNeeded.try context.save()...done")
            } catch {
                print("Failed to saving test data: \(error)")
            }
        }
    }
}
