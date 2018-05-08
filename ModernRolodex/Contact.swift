//
//  Contact.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/6/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

struct Contact {
    let fullName: String
    let additionalInfo: String
    let image: UIImage?
    
    static func goldy() -> Contact {
        return  Contact(fullName: "Paul Goldschmidt",
                        additionalInfo: """
Paul Edward Goldschmidt (born September 10, 1987), nicknamed "Goldy", is an American professional baseball first baseman for the Arizona Diamondbacks of Major League Baseball (MLB). He made his MLB debut with the Diamondbacks in 2011. Goldschmidt is a five-time MLB All-Star. He has won the National League (NL) Hank Aaron Award, Gold Glove Award, and Silver Slugger Award. He has also twice finished runner-up for the NL Major League Baseball Most Valuable Player Award (MVP, in 2013 and 2015).
""",
                        image: UIImage(named: "paul"))
    }
    
    static func archie() -> Contact {
        return Contact(fullName: "Archie Bradley",
                       additionalInfo: """
Archie N. Bradley (born August 10, 1992) is an American professional baseball pitcher for the Arizona Diamondbacks of Major League Baseball (MLB). He was drafted seventh overall by the Diamondbacks.
""",
                       image: UIImage(named: "archie"))
    }
    
    static func dummyContacts() -> [Contact] {
        return [
            archie(), goldy()
        ]
    }
}
