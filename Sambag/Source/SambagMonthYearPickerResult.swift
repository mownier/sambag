//
//  SambagMonthYearPickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 03/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

public struct SambagMonthYearPickerResult {

    public var month: SambagMonth
    public var year: Int
    
    public init() {
        self.month = .january
        self.year = 0
    }
}

extension SambagMonthYearPickerResult: CustomStringConvertible {
    
    public var description: String {
        return "\(month) \(year)"
    }
}

public enum SambagMonth: Int {
    
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension SambagMonth: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .january: return "JAN"
        case .february: return "FEB"
        case .march: return "MAR"
        case .april: return "APR"
        case .may: return "MAY"
        case .june: return "JUN"
        case .july: return "JUL"
        case .august: return "AUG"
        case .september: return "SEP"
        case .october: return "OCT"
        case .november: return "NOV"
        case .december: return "DEC"
        }
    }
}
