//
//  ContactCollectionViewCell.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/5/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    public let contactView = ContactView()
    
    private lazy var widthAnchorConstraint: NSLayoutConstraint = {
        let c = self.contactView.widthAnchor.constraint(equalToConstant: 0)
        // there are times where a collection view cell's content view has its own constraints
        // that we conflict with -- they aren't actually a problem, so instead of messing with
        // uikit's built-in constraints, we'll just give ours a slightly lower priority.
        c.priority = UILayoutPriority(999)
        return c
    }()
    
    public var widthAnchorConstant: CGFloat {
        get {
            return self.widthAnchorConstraint.constant
        }
        set {
            self.widthAnchorConstraint.isActive = false
            self.widthAnchorConstraint.constant = newValue
            self.widthAnchorConstraint.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cardView = CardView()
        cardView.addConstrainedSubview(self.contactView)
        self.contactView.constraints(to: cardView.contentView).forEach { $0.isActive = true }
        
        self.contentView.addConstrainedSubview(cardView)
        cardView.constraints(to: self.contentView).forEach { $0.isActive = true }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
