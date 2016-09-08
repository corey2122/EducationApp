//
//  ColorManager.swift
//  ParticipationApp
//
//  Created by CJS  on 8/1/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

class ColorManager {
    
    func colorFromRGBHexString(RGBHexString : String) -> UIColor {
        if RGBHexString.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) != 6 {
            return UIColor.grayColor()
        }
        let redInt = hexStringToInt((RGBHexString as NSString).substringWithRange(NSRange(location: 0, length: 2)))
        let greenInt = hexStringToInt((RGBHexString as NSString).substringWithRange(NSRange(location: 2, length: 2)))
        let blueInt = hexStringToInt((RGBHexString as NSString).substringWithRange(NSRange(location: 4, length: 2)))
        
        let red = CGFloat(redInt) / 255
        let green = CGFloat(greenInt) / 255
        let blue = CGFloat(blueInt) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func hexStringToInt(hexString : String) -> Int {
        var value : Int = 0
        
        for hexChar in hexString.lowercaseString.characters {
            let hexCharValue = "0123456789abcdef".rangeOfString("\(hexChar)").location
            value = (value * 16 ) + hexCharValue
        }
        return value
    }
    
    func hexStringFromInt(value:Int) -> String {
        return NSString(format:"%02X", value) as String
    }
}
