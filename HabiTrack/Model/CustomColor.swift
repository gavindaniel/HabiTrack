//
//  CustomColor.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/19/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


// custom : setDefaults
func setColorDefaults() {
    if (isKeyPresentInUserDefaults(key: "defaultColor") == false) {
        let defaults = UserDefaults.standard
        let colorString = "blue"
        defaults.set(colorString, forKey: "defaultColor")
    }
}

func getSystemColor() -> UIColor {
    let colorString = UserDefaults.standard.object(forKey: "defaultColor") as! String
    switch colorString {
        case "teal":
            return UIColor.systemTeal
        case "blue":
            return UIColor.systemBlue
        case "indigo":
            if #available(iOS 13.0, *) {
                return UIColor.systemIndigo
            } else {
                // Fallback on earlier versions
                return UIColor.systemBlue
            }
        case "purple":
            return UIColor.systemPurple
        case "pink":
            return UIColor.systemPink
        case "red":
            return UIColor.systemRed
        case "orange":
            return UIColor.systemOrange
        default:
            return UIColor.systemBlue
    }
}

func getColor(colorString: String) -> UIColor {
    switch colorString {
        case "teal":
            return UIColor.systemTeal
        case "blue":
            return UIColor.systemBlue
        case "indigo":
            if #available(iOS 13.0, *) {
                return UIColor.systemIndigo
            } else {
                // Fallback on earlier versions
                return UIColor.systemBlue
            }
        case "purple":
            return UIColor.systemPurple
        case "pink":
            return UIColor.systemPink
        case "red":
            return UIColor.systemRed
        case "orange":
            return UIColor.systemOrange
        default:
            return UIColor.systemBlue
    }
}

func getColorString(color: UIColor) -> String {
    if #available(iOS 13.0, *) {
        switch color {
            case UIColor.systemTeal:
                return "teal"
            case UIColor.systemBlue:
                return "blue"
            case UIColor.systemIndigo:
                return "indigo"
            case UIColor.systemPurple:
                return "purple"
            case UIColor.systemPink:
                return "pink"
            case UIColor.systemRed:
                return "red"
            case UIColor.systemOrange:
                return "orange"
            default:
                return "blue"
        }
    } else {
        // Fallback on earlier versions (no Indigo)
        switch color {
            case UIColor.systemTeal:
                return "teal"
            case UIColor.systemBlue:
                return "blue"
            case UIColor.systemPurple:
                return "purple"
            case UIColor.systemPink:
                return "pink"
            case UIColor.systemRed:
                return "red"
            case UIColor.systemOrange:
                return "orange"
            default:
                return "blue"
        }
    }
}
