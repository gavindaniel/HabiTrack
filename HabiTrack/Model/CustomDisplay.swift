//
//  CustomDisplay.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/23/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


// name: setDisplayDefaults
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func setDisplayDefaults() {
    debugPrint("CustomDisplay", "setDisplayDefaults", "start", true)
    if (isKeyPresentInUserDefaults(key: "showRepeat") == false) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "showRepeat")
    }
    if (isKeyPresentInUserDefaults(key: "showLongest") == false) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "showLongest")
    }
    debugPrint("CustomDisplay", "setDisplayDefaults", "end", true)
}


// name: getShowRepeatLabel
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getShowRepeatLabel() -> Bool {
    debugPrint("CustomDisplay", "getShowRepeatLabel", "start", true)
    let showRepeat = UserDefaults.standard.object(forKey: "showRepeat") as! Bool
    debugPrint("CustomDisplay", "getShowRepeatLabel", "end", true)
    return showRepeat
}


// name: getShowLongestLabel
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getShowLongestLabel() -> Bool {
    debugPrint("CustomDisplay", "getShowLongestLabel", "start", true)
    let showLongest = UserDefaults.standard.object(forKey: "showLongest") as! Bool
    debugPrint("CustomDisplay", "getShowLongestLabel", "end", true)
    return showLongest
}


// name: toggleShowRepeatLabel
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func toggleShowRepeatLabel() {
    debugPrint("CustomDisplay", "toggleShowRepeatLabel", "start", true)
    let showRepeat = UserDefaults.standard.object(forKey: "showRepeat") as! Bool
    if (showRepeat) {
        UserDefaults.standard.set(false, forKey: "showRepeat")
    } else {
        UserDefaults.standard.set(true, forKey: "showRepeat")
    }
    debugPrint("CustomDisplay", "toggleShowRepeatLabel", "end", true)
}


// name: toggleShowLongestLabel
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func toggleShowLongestLabel() {
    debugPrint("CustomDisplay", "toggleShowLongestLabel", "start", true)
    let showRepeat = UserDefaults.standard.object(forKey: "showLongest") as! Bool
    if (showRepeat) {
        UserDefaults.standard.set(false, forKey: "showLongest")
    } else {
        UserDefaults.standard.set(true, forKey: "showLongest")
    }
    debugPrint("CustomDisplay", "toggleShowLongestLabel", "end", true)
}
