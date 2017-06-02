//
//  SambagTimePickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 02/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagTimePickerResult {
    
    public var hour: Int
    public var minute: Int
    public var meridian: TimeMeridian
    
    public init() {
        self.hour = 0
        self.minute = 0
        self.meridian  = .am
    }
}

extension SambagTimePickerResult: CustomStringConvertible {
    
    public var description: String {
        return "\(hour):\(minute) \(meridian)"
    }
}
