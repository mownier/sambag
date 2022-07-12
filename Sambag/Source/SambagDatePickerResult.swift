//
//  SambagDatePickerResult.swift
//  Sambag
//
//  Created by Mounir Ybanez on 03/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import Foundation

public struct SambagDatePickerResult {
    
    public var month: SambagMonth
    public var year: Int
    public var day: Int
    public var asDate: Date? {
        var dateComps = DateComponents()
        dateComps.year = year
        dateComps.month = month.rawValue
        dateComps.day = day
        return Calendar.current.date(from: dateComps)
    }
    public var dayOfWeek: SambagDayOfWeek? {
        if let date = asDate {
            let dayOfWeek = Calendar.current.component(.weekday, from: date)
            return SambagDayOfWeek(rawValue: dayOfWeek)
        }
        return nil
    }
    
    public init() {
        self.month = .january
        self.year = 0
        self.day = 0
    }
}

extension SambagDatePickerResult: CustomStringConvertible {
    
    public var description: String {
        return "\(month) \(day), \(year)"
    }
}

extension SambagDatePickerResult: Equatable {
    
    public static func ==(lhs: SambagDatePickerResult, rhs: SambagDatePickerResult) -> Bool {
        return lhs.month == rhs.month && lhs.year == rhs.year && lhs.day == rhs.day
    }
}

public protocol SambagDatePickerResultValidator {
    
    func isValidResult(_ result: SambagDatePickerResult) -> Bool
}

extension SambagDatePickerResult {
    
    public class Validator: SambagDatePickerResultValidator {
        
        var formatter: DateFormatter
        
        init(dateFormat: String = "MMM dd, yyyy") {
            self.formatter = DateFormatter()
            self.formatter.dateFormat = dateFormat
        }
        
        public func isValidResult(_ result: SambagDatePickerResult) -> Bool {
            return formatter.date(from: "\(result)") != nil
        }
    }
}

public protocol SambagDatePickerResultSuggestor {
    
    func suggestedResult(from result: SambagDatePickerResult) -> SambagDatePickerResult
}

extension SambagDatePickerResult {
    
    public class Suggestor: SambagDatePickerResultSuggestor {
        
        var validator: SambagDatePickerResultValidator
        var monthsWith31Days: [SambagMonth] = [
            .january, .march, .may, .july, .august, .october, .december
        ]
        
        init(validator: SambagDatePickerResultValidator = SambagDatePickerResult.Validator()) {
            self.validator = validator
        }
        
        public func suggestedResult(from result: SambagDatePickerResult) -> SambagDatePickerResult {
            var result = result
            
            guard !validator.isValidResult(result) else {
                return result
            }
            
            if result.month == .february {
                if isLeapYear(result.year), result.day > 29 {
                    result.day = 29
                }
                if !isLeapYear(result.year), result.day > 28 {
                    result.day = 28
                }
                
            } else if !monthsWith31Days.contains(result.month), result.day > 30 {
                result.day = 30
            }
            
            return result
        }
        
        func isLeapYear(_ year: Int) -> Bool {
            return (year % 100 != 0 && year % 4 == 0) || year % 400 == 0
        }
    }
}

public enum SambagDayOfWeek: Int {
    
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension SambagDayOfWeek: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .sunday: return "SUN"
        case .monday: return "MON"
        case .tuesday: return "TUE"
        case .wednesday: return "WED"
        case .thursday: return "THU"
        case .friday: return "FRI"
        case .saturday: return "SAT"
        }
    }
}
