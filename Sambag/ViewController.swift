//
//  ViewController.swift
//  Sambag
//
//  Created by Mounir Ybanez on 01/06/2017.
//  Copyright © 2017 Ner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showSambagTimePickerViewController(_ sender: UIButton) {
        let vc = SambagTimePickerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: SambagTimePickerViewControllerDelegate {
    
    func sambagTimePickerViewDidSet(_ viewController: SambagTimePickerViewController, result: SambagTimePickerResult) {
        print(result)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagTimePickerViewDidCancel(_ viewController: SambagTimePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

