//
//  ViewController.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/4/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var contacts = Contact.dummyContacts()
    
    override func viewDidLoad() {
        let cvc = SelfSizingCollectionViewController()
        let nav = UINavigationController(rootViewController: cvc)
        self.addChildViewController(nav)
        self.view.addConstrainedSubview(nav.view)
        nav.view.constraints(to: self.view).forEach { $0.isActive = true }
        nav.didMove(toParentViewController: self)
    }
}

