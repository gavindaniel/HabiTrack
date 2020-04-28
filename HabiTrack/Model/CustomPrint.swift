//
//  CustomPrint.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 4/28/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation

func debugPrint(_ fileString: String,_ funcString: String,_ startEndString: String,_ printHide: Bool) {
    if (printHide == false) {
        if (startEndString == "start") {
            print()
        }
        print("\(fileString) : \(funcString)...\(startEndString)")
    }
}
