//
//  WheelViewController.swift
//  Sambag
//
//  Created by Mounir Ybanez on 01/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

protocol WheelViewControllerDelegate: AnyObject {
    
    func wheelViewController(_ viewController: WheelViewController, didSelectItemAtRow row: Int)
}

class WheelViewController: UIViewController {
    
    enum SectionAccessoryViewType {
        
        case header, footer
    }
    
    weak var delegate: WheelViewControllerDelegate?
    
    var tableView: UITableView!
    var items: [String] = []
    
    var strip1: UIView!
    var strip2: UIView!
    
    var itemHeight: CGFloat = 0
    var gradientColor: UIColor = .white
    var stripColor: UIColor = .black
    var cellTextColor: UIColor = .black
    var cellTextFont: UIFont! = UIFont(name: "AvenirNext-Medium", size: 15)
    
    var selectedIndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            guard isViewLoaded, items.count > 0,
                selectedIndexPath.row >= 0, selectedIndexPath.row < items.count else {
                    return
            }
            
            tableView.scrollToRow(at: selectedIndexPath, at: .top, animated: true)
            delegate?.wheelViewController(self, didSelectItemAtRow: selectedIndexPath.row)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 0
        tableView.estimatedRowHeight = 0
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.delaysContentTouches = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CellHeaderFooter")
        
        strip1 = UIView()
        strip1.backgroundColor = stripColor
        
        strip2 = UIView()
        strip2.backgroundColor = stripColor
        
        view.addSubview(tableView)
        view.addSubview(strip1)
        view.addSubview(strip2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect.size = view.bounds.size
        tableView.frame = rect
        
        rect.size.height = 2
        rect.size.width = view.bounds.width
        rect.origin.y = view.bounds.height / 3
        strip1.frame = rect
        
        rect.origin.y = (rect.origin.y * 2) - rect.height
        strip2.frame = rect
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.scrollToRow(at: selectedIndexPath, at: .top, animated: true)
    }
    
    func dequeueHeaderFooter(from tableView: UITableView, type: SectionAccessoryViewType) -> UITableViewHeaderFooterView {
        let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CellHeaderFooter")!
        if headerFooter.backgroundView == nil {
            let view = UIView()
            view.backgroundColor = gradientColor.withAlphaComponent(0.7)
            headerFooter.backgroundView = view
        }
        return headerFooter
    }
}

extension WheelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.minimumScaleFactor = 0.1
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = cellTextFont
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = cellTextColor
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
}

extension WheelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return itemHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dequeueHeaderFooter(from: tableView, type: .header)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return dequeueHeaderFooter(from: tableView, type: .footer)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = CGPoint(
            x: scrollView.center.x + scrollView.contentOffset.x,
            y: scrollView.center.y + scrollView.contentOffset.y
        )

        let indexPath = tableView.indexPathForRow(at: point)
        
        guard indexPath != nil else { return }

        selectedIndexPath = indexPath!
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        
        scrollViewDidEndDecelerating(scrollView)
    }
}
