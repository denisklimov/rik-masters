//
//  MyHomeViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 11.05.2023.
//

import UIKit

class MyHomeViewController: UIViewController {
    
    @IBOutlet weak var camerasContainerView: UIView!
    @IBOutlet weak var doorsContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camerasContainerView.alpha = 1
        doorsContainerView.alpha = 0
    }
    

    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            camerasContainerView.alpha = 1
            doorsContainerView.alpha = 0
        case 1:
            camerasContainerView.alpha = 0
            doorsContainerView.alpha = 1
        default:
            break
        }
    }
}
