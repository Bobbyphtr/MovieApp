//
//  DateTimeHelper.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import Foundation

extension Int {
    func toTimeFormatAsMinutes()->String {
        var string : String = ""
        let hour = self / 60
        let minute = self % 60
        if hour > 0 {
            string.append("\(hour)h")
        }
        if minute > 0 {
            string.append(" \(minute)m")
        }
        return string
    }
}
