//
//  CalendarVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 5/1/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation


// name: JournalDateCVCell
// desc: date selection collection view cell class
// last updated: 4/28/2020
// last update: cleaned up
class ChangeDateCVCell: UICollectionViewCell {
    @IBOutlet weak var monthUILabel: UILabel!
    @IBOutlet weak var dayUILabel: UILabel!
}


// name: CalendarVC
// desc: calendar view controller class
// last updated: 5/1/2020
// last update: new
class CalendarVC: UIViewController {

    
    @IBAction func saveChanges(_ sender: Any) {
    }
    
    @IBAction func cancelChanges(_ sender: Any) {
    }
}
