//
//  CustomColor.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/19/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit


// name: setColorDefaults
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func setColorDefaults() {
    debugPrint("CustomColor", "setColorDefaults", "start", true)
    if (isKeyPresentInUserDefaults(key: "defaultColor") == false) {
        let defaults = UserDefaults.standard
        let colorString = "blue"
        defaults.set(colorString, forKey: "defaultColor")
    }
    debugPrint("CustomColor", "setColorDefaults", "end", true)
}


// name: getSystemColor
// desc:
// last updated: 4/28/2020
// last update: cleaned up
//func getSystemColor() -> UIColor {
//    let colorString = UserDefaults.standard.object(forKey: "defaultColor") as! String
//    switch colorString {
//        case "teal":
//            return UIColor.systemTeal
//        case "blue": return UIColor.systemBlue
//        case "indigo":
//            if #available(iOS 13.0, *) {
//                return UIColor.systemIndigo
//            } else {
//                // Fallback on earlier versions
//                return UIColor.systemBlue
//            }
//        case "purple": return UIColor.systemPurple
//        case "pink": return UIColor.systemPink
//        case "red": return UIColor.systemRed
//        case "orange": return UIColor.systemOrange
//        default: return UIColor.systemBlue
//    }
//}


// name: getColor
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getColor(_ colorString: String) -> UIColor {
    debugPrint("CustomColor", "getColor", "start", true)
    var tempColor = colorString
    if (tempColor == "System") {
        tempColor = UserDefaults.standard.object(forKey: "defaultColor") as! String
    }
    debugPrint("CustomColor", "getColor", "end", true)
    switch tempColor {
        case "teal": return UIColor.systemTeal
        case "blue": return UIColor.systemBlue
        case "indigo":
            if #available(iOS 13.0, *) {
                return UIColor.systemIndigo
            } else {
                // Fallback on earlier versions
                return UIColor.systemBlue
            }
        case "purple": return UIColor.systemPurple
        case "pink": return UIColor.systemPink
        case "red": return UIColor.systemRed
        case "orange": return UIColor.systemOrange
        default: return UIColor.systemBlue
    }
}


// name: getColorString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getColorString(color: UIColor) -> String {
    debugPrint("CustomColor", "getColorString", "start", true)
    if #available(iOS 13.0, *) {
        debugPrint("CustomColor", "getColorString", "end", true)
        switch color {
            case UIColor.systemTeal: return "teal"
            case UIColor.systemBlue: return "blue"
            case UIColor.systemIndigo: return "indigo"
            case UIColor.systemPurple: return "purple"
            case UIColor.systemPink: return "pink"
            case UIColor.systemRed: return "red"
            case UIColor.systemOrange: return "orange"
            default: return "blue"
        }
    } else {
        debugPrint("CustomColor", "getColorString", "end", true)
        // Fallback on earlier versions (no Indigo)
        switch color {
            case UIColor.systemTeal: return "teal"
            case UIColor.systemBlue: return "blue"
            case UIColor.systemPurple: return "purple"
            case UIColor.systemPink: return "pink"
            case UIColor.systemRed: return "red"
            case UIColor.systemOrange: return "orange"
            default: return "blue"
        }
    }
}
