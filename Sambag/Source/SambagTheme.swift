//
//  SambagTheme.swift
//  Sambag
//
//  Created by Mounir Ybanez on 02/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

public struct SambagThemeAttribute {

    public var contentViewBackgroundColor: UIColor!
    public var stripColor: UIColor!
    public var titleTextColor: UIColor!
    public var titleFont: UIFont!
    public var wheelFont: UIFont!
    public var wheelTextColor: UIColor!
    public var buttonFont: UIFont!
    public var buttonTextColor: UIColor!
    public var is24:Bool!
    
    public init() {
        contentViewBackgroundColor = .white
        stripColor = UIColor(red: 61/255, green: 187/255, blue: 234/255, alpha: 1)
        titleTextColor = stripColor
        titleFont = UIFont(name: "AvenirNext-Medium", size: 20)
        wheelFont = UIFont(name: "AvenirNext-Medium", size: 15)
        wheelTextColor = .black
        buttonFont = UIFont(name: "AvenirNext-Regular", size: 15)
        buttonTextColor = .black
        is24 = is24Format()
    }
    
    func is24Format() -> Bool {
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if (formatter.contains("a")) {
            return false
        } else {
            return true
        }
    }
}

public enum SambagTheme {
    
    case light
    case dark
    case custom(SambagThemeAttribute)
    
    public var attribute: SambagThemeAttribute {
        switch self {
        case .light:
            return SambagThemeAttribute()
            
        case .dark:
            var attrib = SambagThemeAttribute()
            attrib.contentViewBackgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
            attrib.buttonTextColor = .white
            attrib.wheelTextColor = .white
            return attrib
            
        case .custom(let attrib):
            return attrib
        }
    }
}
