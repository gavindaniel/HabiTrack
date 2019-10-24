//
//  CustomDisplay.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/23/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

// custom : setDefaults
func setDisplayDefaults() {
    if (isKeyPresentInUserDefaults(key: "showRepeat") == false) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "showRepeat")
    }
    if (isKeyPresentInUserDefaults(key: "showLongest") == false) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "showLongest")
    }
}

func getShowRepeatLabel() -> Bool {
    let showRepeat = UserDefaults.standard.object(forKey: "showRepeat") as! Bool
    return showRepeat
}

func getShowLongestLabel() -> Bool {
    let showLongest = UserDefaults.standard.object(forKey: "showLongest") as! Bool
    return showLongest
}

func toggleShowRepeatLabel() {
    let showRepeat = UserDefaults.standard.object(forKey: "showRepeat") as! Bool
    if (showRepeat) {
        UserDefaults.standard.set(false, forKey: "showRepeat")
    } else {
        UserDefaults.standard.set(true, forKey: "showRepeat")
    }
}

func toggleShowLongestLabel() {
    let showRepeat = UserDefaults.standard.object(forKey: "showLongest") as! Bool
    if (showRepeat) {
        UserDefaults.standard.set(false, forKey: "showLongest")
    } else {
        UserDefaults.standard.set(true, forKey: "showLongest")
    }
}
