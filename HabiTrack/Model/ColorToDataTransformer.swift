//
//  ColorToDataTransformer.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 3/28/21.
//  Copyright © 2021 Gavin Daniel. All rights reserved.
//

import UIKit

class ColorToDataTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else {
            fatalError("Wrong data type: value must be a UIColor object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(color)
    }
}

extension NSValueTransformerName {
    static let colorToDataTransformer = NSValueTransformerName(rawValue: "ColorToDataTransformer")
}

