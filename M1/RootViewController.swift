//
//  RootViewController.swift
//  M1
//
//  Created by Lim Liu on 11/29/21.
//

import Foundation
import UIKit

class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreModel.sc.load()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ScoreModel.sc.save()
    }
}
