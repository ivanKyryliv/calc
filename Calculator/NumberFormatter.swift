//
//  NumberFormatterExtension.swift
//  Calculator
//
//  Created by іван on 15.08.17.
//  Copyright © 2017 ivan. All rights reserved.
//

import Foundation
import UIKit
let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 6
    formatter.notANumberSymbol = "Error"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
} ()

