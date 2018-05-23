//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
}
