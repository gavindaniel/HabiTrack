//
//  CustomPrint.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 4/28/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation


// name: debugPrint
// desc: custom debug print formatter
/*
    debugPrint("JournalDateCV", "didSelectItemAt", "start", false)
    debugPrint("JournalDateCV", "didSelectItemAt", "end", false)
    debugPrint("JournalDateCV", "didSelectItemAt", "start", true, indexPath.row)
    debugPrint("JournalDateCV", "didSelectItemAt", "end", true, indexPath.row)
 */
// last updated: 4/28/2020
// last update: cleaned up
func debugPrint(_ fileString: String,_ funcString: String,_ startEndString: String,_ printHide: Bool, _ indexPathRow: Int? = nil) {
    // check if the print statement should be hidden
    if (printHide == false) {
        // check if start of a print start / end statement
        if (startEndString == "start") {
//            print()
        }
        // check if a indexpath row was provided (optional)
        if (indexPathRow != nil) {
            // format ::  debugPrint("JournalDateCV", "didSelectItemAt", "end", true, indexPath.row)
            print("\(fileString) : \(funcString)...\(indexPathRow ?? -1)...\(startEndString)")
        } else {
            // format ::  debugPrint("JournalDateCV", "didSelectItemAt", "end", true)
            print("\(fileString) : \(funcString)...\(startEndString)")
        }
    }
}
