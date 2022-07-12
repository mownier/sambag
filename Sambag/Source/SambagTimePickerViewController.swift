//
//  SambagTimePickerViewController.swift
//  Sambag
//
//  Created by Mounir Ybanez on 01/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

public protocol SambagTimePickerViewControllerDelegate: AnyObject {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult)
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController)
}

@objc protocol SambagTimePickerViewControllerInteraction: AnyObject {
    
    func didTapOkay()
    func didTapCancel()
}

public class SambagTimePickerViewController: UIViewController {

    lazy var alphaTransition = AlphaTransitioning()
    
    var contentView: UIView!
    var titleLabel: UILabel!
    var delimiterLabel: UILabel!
    var strip1: UIView!
    var strip2: UIView!
    var strip3: UIView!
    
    var okayButton: UIButton!
    var cancelButton: UIButton!
    
    var hourWheel: WheelViewController!
    var minuteWheel: WheelViewController!
    var meridianWheel: WheelViewController!
    
    var is24Format:Bool!

    var result: SambagTimePickerResult {
        var result = SambagTimePickerResult()
        
        result.hour = hourWheel.selectedIndexPath.row + (is24Format ? 0 : 1)
        result.minute = minuteWheel.selectedIndexPath.row
        result.meridian = meridianWheel?.selectedIndexPath.row == 0 ? .am : .pm
        result.is24 = is24Format
        return result
    }
    
    public weak var delegate: SambagTimePickerViewControllerDelegate?
    public var theme: SambagTheme = .dark
    
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
        is24Format = attrib.is24
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        contentView = UIView()
        contentView.backgroundColor = attrib.contentViewBackgroundColor
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.text = "Set time"
        titleLabel.textColor = attrib.titleTextColor
        titleLabel.font = attrib.titleFont
        
        delimiterLabel = UILabel()
        delimiterLabel.text = ":"
        delimiterLabel.textColor = attrib.wheelTextColor
        delimiterLabel.font = attrib.wheelFont
        delimiterLabel.textAlignment = .center
        
        okayButton = UIButton()
        okayButton.setTitleColor(attrib.buttonTextColor, for: .normal)
        okayButton.setTitle("Set", for: .normal)
        okayButton.addTarget(self, action: #selector(self.didTapOkay), for: .touchUpInside)
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
        
        var items = [String]()
        
        
        if(is24Format) {
            for i in 0..<24 {
                items.append("\(i)")
            }
        } else {
            for i in 1..<13 {
                items.append("\(i)")
            }
        }
        
        hourWheel = WheelViewController()
        hourWheel.items = items
        hourWheel.gradientColor = attrib.contentViewBackgroundColor
        hourWheel.stripColor = attrib.stripColor
        hourWheel.cellTextFont = attrib.wheelFont
        hourWheel.cellTextColor = attrib.wheelTextColor
        
        items.removeAll()
        for i in 0..<60 {
            i < 10 ? items.append("0\(i)") : items.append("\(i)")
        }
        
        minuteWheel = WheelViewController()
        minuteWheel.items = items
        minuteWheel.gradientColor = hourWheel.gradientColor
        minuteWheel.stripColor = hourWheel.stripColor
        minuteWheel.cellTextFont = hourWheel.cellTextFont
        minuteWheel.cellTextColor = hourWheel.cellTextColor
        
        let now = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        if(!is24Format) {
            items.removeAll()
            items.append(contentsOf: ["AM", "PM"])
            
            meridianWheel = WheelViewController()
            meridianWheel.items = items
            meridianWheel.gradientColor = hourWheel.gradientColor
            meridianWheel.stripColor = hourWheel.stripColor
            meridianWheel.cellTextFont = hourWheel.cellTextFont
            meridianWheel.cellTextColor = hourWheel.cellTextColor
            
            let meridian = hour >= 12 && hour < 24 ? 1 : 0
            hour = hour % 12
            hour = hour == 0 ? 12 : hour
            hour -= 1
            
            meridianWheel.selectedIndexPath = IndexPath(row: meridian, section: 0)
        }
        
        hourWheel.selectedIndexPath = IndexPath(row: hour, section: 0)
        minuteWheel.selectedIndexPath = IndexPath(row: minute, section: 0)
        
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
        
        let wheelWidth: CGFloat = is24Format ? 72 : 56
        let wheelSpacing: CGFloat = 24
        let totalWidth: CGFloat = is24Format ? (wheelWidth * 2 + wheelSpacing) : wheelWidth * 3 + wheelSpacing * 2
        
        rect.origin.y = rect.maxY + 20
        rect.size.width = wheelWidth
        rect.size.height = 210
        rect.origin.x = (contentViewWidth - totalWidth) / 2
        hourWheel.itemHeight = rect.height / 3
        hourWheel.view.frame = rect
        
        var delimiterRect = rect
        delimiterRect.size.width = wheelSpacing
        delimiterRect.origin.x = rect.maxX
        delimiterLabel.frame = delimiterRect
        
        rect.origin.x = rect.maxX + wheelSpacing
        minuteWheel.itemHeight = hourWheel.itemHeight
        minuteWheel.view.frame = rect
        
        if(is24Format) {
            
        } else {
            rect.origin.x = rect.maxX + wheelSpacing
            meridianWheel.itemHeight = hourWheel.itemHeight
            meridianWheel.view.frame = rect
        }
        
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
            contentView.addSubview(delimiterLabel)
            contentView.addSubview(hourWheel.view)
            contentView.addSubview(minuteWheel.view)
            
            if(!is24Format) {
                contentView.addSubview(meridianWheel.view)
                addChild(meridianWheel)
                meridianWheel.didMove(toParent: self)
            }
            
            addChild(hourWheel)
            addChild(minuteWheel)
            
            hourWheel.didMove(toParent: self)
            minuteWheel.didMove(toParent: self)
            
        }
    }
    
    func initSetup() {
        transitioningDelegate = alphaTransition
        modalPresentationStyle = .custom
    }
}

extension SambagTimePickerViewController: SambagTimePickerViewControllerInteraction {
    
    func didTapOkay() {
        delegate?.sambagTimePickerDidSet(self, result: result)
    }
    
    func didTapCancel() {
        delegate?.sambagTimePickerDidCancel(self)
    }
}
