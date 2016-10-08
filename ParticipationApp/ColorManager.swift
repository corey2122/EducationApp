//
//  ColorManager.swift
//  ParticipationApp
//
//  Created by CJS  on 8/1/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

class ColorManager {
    func colorFromRGBHexString(_ RGBHexString: String) -> UIColor {
        if RGBHexString.lengthOfBytes(using: String.Encoding.ascii) != 6 {
            return UIColor.gray
        }
        
        let redInt = hexStringToInt((RGBHexString as NSString).substring(with: NSRange(location: 0, length: 2)))
        let greenInt = hexStringToInt((RGBHexString as NSString).substring(with: NSRange(location: 2, length: 2)))
        let blueInt = hexStringToInt((RGBHexString as NSString).substring(with: NSRange(location: 4, length: 2)))
        
        let red = CGFloat(redInt) / 255
        let green = CGFloat(greenInt) / 255
        let blue = CGFloat(blueInt) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func hexStringToInt(_ hexString: String) -> Int {
        return Int(strtoul(hexString, nil, 16))
    }
    
    func hexStringFromInt(_ value: Int) -> String {
        return NSString(format:"%02X", value) as String
}
}
