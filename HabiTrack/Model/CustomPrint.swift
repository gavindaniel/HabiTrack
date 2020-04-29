//
//  CustomPrint.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 4/28/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation


// name: init
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func debugPrint(_ fileString: String,_ funcString: String,_ startEndString: String,_ printHide: Bool, _ indexPathRow: Int? = nil) {
    if (printHide == false) {
        if (startEndString == "start") {
            print()
        }
        if (indexPathRow != nil) {
            print("\(fileString) : \(funcString)...\(indexPathRow ?? -1)...\(startEndString)")
        } else {
            print("\(fileString) : \(funcString)...\(startEndString)")
        }
    }
}
