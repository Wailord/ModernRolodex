//
//  ContactView.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/5/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

class ContactView: UIView {
    public let photoImageView = with(UIImageView()) {
        $0.backgroundColor = .blue
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 3.0
        $0.layer.masksToBounds = true
    }
    
    public let fullNameLabel = with(UILabel()) {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    public let additionalInfoLabel = with(UILabel()) {
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    public func apply(_ contact: Contact) {
        self.fullNameLabel.text = contact.fullName
        self.additionalInfoLabel.text = contact.additionalInfo
        self.photoImageView.image = contact.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 255, green: 255, blue: 204)
        
        // photo is always, no matter what, anchored to the top/left with 80hx60h
        self.addConstrainedSubview(self.photoImageView)
        self.photoImageView.topAnchor.constraintEqualToSystemSpacingBelow(self.topAnchor, multiplier: 1.0).isActive = true
        self.photoImageView.leftAnchor.constraintEqualToSystemSpacingAfter(self.leftAnchor, multiplier: 1.0).isActive = true
        self.photoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.photoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.bottomAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(self.photoImageView.bottomAnchor, multiplier: 1.0).isActive = true
        
        let hugButtom = self.bottomAnchor.constraintEqualToSystemSpacingBelow(self.photoImageView.bottomAnchor, multiplier: 1.0)
        hugButtom.priority = .defaultHigh
        hugButtom.isActive = true
        
        // name should always be pinned to the top of the card and right of the photo; if someone gives us a high-priority width,
        // though, we want the right to stretch out, so give that a lower priority
        self.addConstrainedSubview(self.fullNameLabel)
        self.fullNameLabel.topAnchor.constraintEqualToSystemSpacingBelow(self.topAnchor, multiplier: 1.0).isActive = true
        self.fullNameLabel.leftAnchor.constraintEqualToSystemSpacingAfter(self.photoImageView.rightAnchor, multiplier: 1.0).isActive = true
        self.rightAnchor.constraintGreaterThanOrEqualToSystemSpacingAfter(self.fullNameLabel.rightAnchor, multiplier: 1.0).isActive = true
        
        let hugRight = self.rightAnchor.constraintEqualToSystemSpacingAfter(self.fullNameLabel.rightAnchor, multiplier: 1.0)
        hugRight.priority = .defaultHigh
        hugRight.isActive = true
        
        self.addConstrainedSubview(self.additionalInfoLabel)
        self.additionalInfoLabel.topAnchor.constraintEqualToSystemSpacingBelow(self.fullNameLabel.bottomAnchor, multiplier: 1.0).isActive = true
        self.additionalInfoLabel.leftAnchor.constraintEqualToSystemSpacingAfter(self.photoImageView.rightAnchor, multiplier: 1.0).isActive = true
        self.rightAnchor.constraintEqualToSystemSpacingAfter(self.additionalInfoLabel.rightAnchor, multiplier: 1.0).isActive = true
        self.bottomAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(self.additionalInfoLabel.bottomAnchor, multiplier: 1.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
