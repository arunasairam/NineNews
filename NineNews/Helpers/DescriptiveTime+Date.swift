//
//  DescriptiveTime+Date.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

extension Date {
    var elapsedTimeString: String? {
        let components = Calendar.current.dateComponents([.year, .weekOfYear, .day, .hour, .minute], from: self, to: Date())
        
        if let year = components.year, year > 0 {
            return "\(year) \("year".pluralized(count: year)) ago"
        } else if let month = components.month, month > 0 {
            return "\(month) \("month".pluralized(count: month)) ago"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week) \("week".pluralized(count: week)) ago"
        } else if let day = components.day, day > 0 {
            return "\(day) \("d".pluralized(count: day)) ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) \("hr".pluralized(count: hour)) ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) \("min".pluralized(count: minute)) ago"
        } else if let second = components.second, second > 0 {
            return "Just now"
        } else {
            return nil
        }
    }
}

extension String {
    func pluralized(count: Int) -> String {
        if count > 1 {
            return "\(self)s"
        } else {
            return self
        }
    }
}
