//
//  StringExtension.swift
//  FraternityRushBuddy
//
//  Created by Joseph Carroll on 2/3/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}