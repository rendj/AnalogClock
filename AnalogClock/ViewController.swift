//
//  ViewController.swift
//  AnalogClock
//
//  Created by Andrii on 7/13/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Clock().draw(on: view)
    }
}
