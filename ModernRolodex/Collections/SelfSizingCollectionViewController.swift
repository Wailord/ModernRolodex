//
//  SelfSizingCollectionViewController.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/5/18.
//  Copyright © 2018 Wailord. All rights reserved.
//
import UIKit

class SelfSizingCollectionViewController: UICollectionViewController {
    private var contacts: [Contact] = Contact.dummyContacts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: "contact")
        self.collectionView?.backgroundColor = .white
        self.collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contact", for: indexPath) as! ContactCollectionViewCell
        let contact = self.contacts[indexPath.item]
        cell.contactView.apply(contact)
        cell.widthAnchorConstant = self.usableWidthPerItem
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    private var usableWidthPerItem: CGFloat {
        get {
            // how much width can we use in total right now?
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            let contentInsets = self.collectionView!.contentInset.left + self.collectionView!.contentInset.right
            let sectionInsets = layout.sectionInset.left + layout.sectionInset.right
            
            let usableWidth = self.collectionView!.frame.width - contentInsets - sectionInsets - 2
            let intercardSpacingPerRow = (CGFloat(2) - 1) * layout.minimumInteritemSpacing
            let usableWidthPerCard = (usableWidth - intercardSpacingPerRow) / CGFloat(2)
            return usableWidthPerCard
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 300, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.minimumInteritemSpacing = 15
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelfSizingCollectionViewController {
    public override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let old = self.contacts[sourceIndexPath.item]
        self.contacts.remove(at: sourceIndexPath.item)
        self.contacts.insert(old, at: destinationIndexPath.item)
    }
}
