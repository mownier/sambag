//
//  SambagSelectionLimit.swift
//  Sambag
//
//  Created by Mounir Ybanez on 7/12/22.
//  Copyright © 2022 Ner. All rights reserved.
//

import Foundation

public struct SambagSelectionLimit {
    public var minDate: Date?
    public var maxDate: Date?
    public var selectedDate: Date = Date()
    public var isValid: Bool {
        guard let min = minDate, let max = maxDate else {
            return false
        }
        return min <= max && (min...max).contains(selectedDate)
    }
    public init() { }
}
