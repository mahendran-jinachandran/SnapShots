//
//  DoubleExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 02/01/23.
//

import Foundation

extension Double {
    var shortStringRepresentation: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        
        if self == 0 {
            return "0"
        }
        
        let units = ["", "k", "M"]
        var interval = self
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }

        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval))\(units[i])"
    }
}
