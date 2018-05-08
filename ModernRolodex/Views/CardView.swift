//
//  CardView.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/4/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    public let contentView = with(UIView()) {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 3.0
        $0.backgroundColor = .red
    }
    
    private let shadowedView = with(UIView()) {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 2.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addConstrainedSubview(self.shadowedView)
        self.shadowedView.constraints(to: self).forEach { $0.isActive = true }
    
        self.addConstrainedSubview(self.contentView)
        self.contentView.constraints(to: self).forEach { $0.isActive = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
