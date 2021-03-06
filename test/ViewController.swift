//
//  ViewController.swift
//  test
//
//  Created by HK on 2021/1/27.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstView.isHidden = false
        secondView.isHidden = true
        thirdView.isHidden = true
    }
    

    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            firstView.isHidden = false
            secondView.isHidden = true
            thirdView.isHidden = true
        case 1:
            firstView.isHidden = true
            secondView.isHidden = false
            thirdView.isHidden = true
        case 2:
            firstView.isHidden = true
            secondView.isHidden = true
            thirdView.isHidden = false
        default:
            break
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
}

