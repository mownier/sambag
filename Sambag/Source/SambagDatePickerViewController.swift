//
//  SambagDatePickerViewController.swift
//  Sambag
//
//  Created by Mounir Ybanez on 03/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

public protocol SambagDatePickerViewControllerDelegate: AnyObject {
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult)
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController)
}

@objc protocol SambagDatePickerViewControllerInteraction: AnyObject {
    
    func didTapSet()
    func didTapCancel()
}

public class SambagDatePickerViewController: UIViewController {
    
    lazy var alphaTransition = AlphaTransitioning()
    
    var contentView: UIView!
    var titleLabel: UILabel!
    var strip1: UIView!
    var strip2: UIView!
    var strip3: UIView!
    
    var okayButton: UIButton!
    var cancelButton: UIButton!
    
    var dayOfWeekWheel: WheelViewController!
    var monthWheel: WheelViewController!
    var yearWheel: WheelViewController!
    var dayWheel: WheelViewController!
    
    var result: SambagDatePickerResult {
        var result = SambagDatePickerResult()
        result.month = SambagMonth(rawValue: monthWheel.selectedIndexPath.row + 1)!
        result.year = Int(yearWheel.items[yearWheel.selectedIndexPath.row])!
        result.day = dayWheel.selectedIndexPath.row + 1
        return result
    }
    
    public weak var delegate: SambagDatePickerViewControllerDelegate?
    public var theme: SambagTheme = .dark
    public var suggestor: SambagDatePickerResultSuggestor = SambagDatePickerResult.Suggestor()
    public var limit: SambagSelectionLimit?
    public var hasDayOfWeek: Bool = false
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    public override func loadView() {
        super.loadView()
        
        let attrib = theme.attribute
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        contentView = UIView()
        contentView.backgroundColor = attrib.contentViewBackgroundColor
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.text = "Set date"
        titleLabel.textColor = attrib.titleTextColor
        titleLabel.font = attrib.titleFont
        
        okayButton = UIButton()
        okayButton.setTitleColor(attrib.buttonTextColor, for: .normal)
        okayButton.setTitle("Set", for: .normal)
        okayButton.addTarget(self, action: #selector(self.didTapSet), for: .touchUpInside)
        okayButton.titleLabel?.font = attrib.buttonFont
        
        cancelButton = UIButton()
        cancelButton.setTitleColor(attrib.buttonTextColor, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        cancelButton.titleLabel?.font = attrib.buttonFont
        
        strip1 = UIView()
        strip1.backgroundColor = attrib.stripColor
        
        strip2 = UIView()
        strip2.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        strip3 = UIView()
        strip3.backgroundColor = strip2.backgroundColor
        
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        var items = [String]()
        for i in 1..<13 {
            let month = SambagMonth(rawValue: i)!
            items.append("\(month)")
        }
        
        monthWheel = WheelViewController()
        monthWheel.delegate = self
        monthWheel.items = items
        monthWheel.gradientColor = attrib.contentViewBackgroundColor
        monthWheel.stripColor = attrib.stripColor
        monthWheel.cellTextFont = attrib.wheelFont
        monthWheel.cellTextColor = attrib.wheelTextColor
        monthWheel.selectedIndexPath.row = month - 1
        
        items.removeAll()
        let offset: Int = 101
        for i in 1..<offset {
            items.append("\(year - (offset - i))")
        }
        for i in 0..<offset {
            items.append("\(year + i)")
        }
        
        yearWheel = WheelViewController()
        yearWheel.delegate = self
        yearWheel.items = items
        yearWheel.gradientColor = monthWheel.gradientColor
        yearWheel.stripColor = monthWheel.stripColor
        yearWheel.cellTextFont = monthWheel.cellTextFont
        yearWheel.cellTextColor = monthWheel.cellTextColor
        yearWheel.selectedIndexPath.row = offset - 1
        
        items.removeAll()
        for i in 1..<32 {
            items.append("\(i)")
        }
        
        dayWheel = WheelViewController()
        dayWheel.delegate = self
        dayWheel.items = items
        dayWheel.gradientColor = monthWheel.gradientColor
        dayWheel.stripColor = monthWheel.stripColor
        dayWheel.cellTextFont = monthWheel.cellTextFont
        dayWheel.cellTextColor = monthWheel.cellTextColor
        dayWheel.selectedIndexPath.row = day - 1
        
        if hasDayOfWeek {
            let dayOfWeek = calendar.component(.weekday, from: now)
            items.removeAll()
            for i in 1...7 {
                let dayOfWeek = SambagDayOfWeek(rawValue: i)!
                items.append("\(dayOfWeek)")
            }
            dayOfWeekWheel = WheelViewController()
            dayOfWeekWheel.items = items
            dayOfWeekWheel.gradientColor = monthWheel.gradientColor
            dayOfWeekWheel.stripColor = monthWheel.stripColor
            dayOfWeekWheel.cellTextFont = monthWheel.cellTextFont
            dayOfWeekWheel.cellTextColor = monthWheel.cellTextColor
            dayOfWeekWheel.selectedIndexPath.row = dayOfWeek - 1
        }
        
        guard
            let selectionLimit = limit,
            let minDate = selectionLimit.minDate,
            let maxDate = selectionLimit.maxDate,
            selectionLimit.isValid else {
            return
        }
        
        let selectedDate = selectionLimit.selectedDate
        let minYear = calendar.component(.year, from: minDate)
        let maxYear = calendar.component(.year, from: maxDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedDay = calendar.component(.day, from: selectedDate)
        let selectedDayOfWeek = calendar.component(.weekday, from: selectedDate)
        
        let years: [Int] = (minYear...maxYear).map { $0 }
        yearWheel.items = years.map { "\($0)" }
        if let index = years.firstIndex(of: selectedYear) {
            yearWheel.selectedIndexPath.row = index
        }
        monthWheel.selectedIndexPath.row = selectedMonth - 1
        dayWheel.selectedIndexPath.row = selectedDay - 1
        dayOfWeekWheel?.selectedIndexPath.row = selectedDayOfWeek - 1
    }
    
    public override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        let contentViewHorizontalMargin: CGFloat = 20
        let contentViewWidth: CGFloat = min(368, view.frame.width - contentViewHorizontalMargin * 2)
        
        rect.origin.x = 20
        rect.size.width = contentViewWidth - rect.origin.x * 2
        rect.origin.y = 20
        rect.size.height = titleLabel.sizeThatFits(rect.size).height
        titleLabel.frame = rect
        
        rect.origin.x = 0
        rect.origin.y = rect.maxY + rect.origin.y
        rect.size.width = contentViewWidth
        rect.size.height = 2
        strip1.frame = rect
        
        let wheelWidth: CGFloat = 72
        let dayWheelWidth: CGFloat = 52
        let wheelSpacing: CGFloat = 24
        var totalWidth: CGFloat = (wheelWidth * 2) + dayWheelWidth + (wheelSpacing * 2)
        if hasDayOfWeek {
            totalWidth += (wheelWidth + wheelSpacing)
        }
        
        rect.origin.y = rect.maxY + 20
        rect.size.width = wheelWidth
        rect.size.height = 210
        rect.origin.x = (contentViewWidth - totalWidth) / 2
        
        if let wheel = dayOfWeekWheel {
            wheel.itemHeight = rect.height / 3
            wheel.view.frame = rect
            
            rect.origin.x = rect.maxX + wheelSpacing
            rect.size.width = wheelWidth
            monthWheel.itemHeight = wheel.itemHeight
            monthWheel.view.frame = rect
        } else {
            monthWheel.itemHeight = rect.height / 3
            monthWheel.view.frame = rect
        }
        
        rect.origin.x = rect.maxX + wheelSpacing
        rect.size.width = dayWheelWidth
        dayWheel.itemHeight = monthWheel.itemHeight
        dayWheel.view.frame = rect
        
        rect.origin.x = rect.maxX + wheelSpacing
        rect.size.width = wheelWidth
        yearWheel.itemHeight = monthWheel.itemHeight
        yearWheel.view.frame = rect
        
        rect.origin.y = rect.maxY + 20
        rect.origin.x = 0
        rect.size.width = strip1.frame.width
        rect.size.height = 1
        strip2.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.width = (contentViewWidth / 2) - 1
        rect.size.height = 48
        cancelButton.frame = rect
        
        rect.origin.x = rect.maxX
        rect.size.width = 1
        strip3.frame = rect
        
        rect.origin.x = rect.maxX
        rect.size.width = cancelButton.frame.width
        okayButton.frame = rect
        
        rect.size.height = rect.maxY
        rect.size.width = contentViewWidth
        rect.origin.x = (view.frame.width - rect.width) / 2
        rect.origin.y = (view.frame.height - rect.height) / 2
        contentView.frame = rect
        contentView.bounds.size = rect.size
        
        if view.frame.height < rect.height + 10 {
            let scale = view.frame.height / (rect.height + 10)
            contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        } else {
            contentView.transform = CGAffineTransform.identity
        }
        
        if(contentView.superview == nil) {
            view.addSubview(contentView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(strip1)
            contentView.addSubview(strip2)
            contentView.addSubview(strip3)
            contentView.addSubview(okayButton)
            contentView.addSubview(cancelButton)
            if let view = dayOfWeekWheel?.view {
                view.isUserInteractionEnabled = false
                contentView.addSubview(view)
            }
            contentView.addSubview(monthWheel.view)
            contentView.addSubview(yearWheel.view)
            contentView.addSubview(dayWheel.view)
            
            if let wheel = dayOfWeekWheel {
                addChild(wheel)
            }
            addChild(monthWheel)
            addChild(yearWheel)
            addChild(dayWheel)
            dayOfWeekWheel?.didMove(toParent: self)
            monthWheel.didMove(toParent: self)
            yearWheel.didMove(toParent: self)
            dayWheel.didMove(toParent: self)
        }
    }
    
    func initSetup() {
        transitioningDelegate = alphaTransition
        modalPresentationStyle = .custom
    }
}

extension SambagDatePickerViewController: SambagDatePickerViewControllerInteraction {
    
    func didTapSet() {
        delegate?.sambagDatePickerDidSet(self, result: result)
    }
    
    func didTapCancel() {
        delegate?.sambagDatePickerDidCancel(self)
    }
}

extension SambagDatePickerViewController: WheelViewControllerDelegate {
    
    func wheelViewController(_ wheel: WheelViewController, didSelectItemAtRow row: Int) {
        let suggested = suggestor.suggestedResult(from: result)
        
        defer {
            if let wheel = dayOfWeekWheel, let date = suggested.asDate {
                let dayOfWeek = Calendar.current.component(.weekday, from: date)
                wheel.selectedIndexPath.row = dayOfWeek - 1
            }
        }
        
        guard suggested != result else {
            return
        }
        
        if suggested.month != result.month {
            monthWheel.selectedIndexPath.row = suggested.month.rawValue - 1
        }
        
        if suggested.day != result.day {
            dayWheel.selectedIndexPath.row = suggested.day - 1
        }
        
        if suggested.year != result.year {
            yearWheel.selectedIndexPath.row = suggested.year - 1
        }
    }
}
