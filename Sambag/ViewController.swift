//
//  ViewController.swift
//  Sambag
//
//  Created by Mounir Ybanez on 01/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var theme: SambagTheme = .light
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func showSambagTimePickerViewController(_ sender: UIButton) {
        let vc = SambagTimePickerViewController()
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showSambagMonthYearPickerViewController(_ sender: UIButton) {
        let vc = SambagMonthYearPickerViewController()
        var limit = SambagSelectionLimit()
        limit.selectedDate = Date()
        let calendar = Calendar.current
        limit.minDate = calendar.date(
            byAdding: .year,
            value: -50,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        limit.maxDate = calendar.date(
            byAdding: .year,
            value: 50,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        vc.limit = limit
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)

    }
    
    @IBAction func showSambagDatePickerViewController(_ sender: UIButton) {
        let vc = SambagDatePickerViewController()
        var limit = SambagSelectionLimit()
        limit.selectedDate = Date()
        let calendar = Calendar.current
        limit.minDate = calendar.date(
            byAdding: .year,
            value: -50,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        limit.maxDate = calendar.date(
            byAdding: .year,
            value: 50,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        vc.limit = limit
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)

    }
    
    @IBAction func didChangeTheme() {
        switch theme {
        case .light: theme = .dark
        case .dark: theme = .light
        default: break
        }
    }
}

extension ViewController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult) {
        resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: SambagMonthYearPickerViewControllerDelegate {

    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: SambagDatePickerViewControllerDelegate {

    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        resultLabel.text = "\(result)"
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

