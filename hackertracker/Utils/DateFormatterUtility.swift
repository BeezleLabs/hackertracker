//
//  DateFormatterUtility.swift
//  hackertracker
//
//  Created by Seth W Law on 6/7/22.
//

import Foundation

class DateFormatterUtility {
    var timeZone = TimeZone(identifier: "America/Los_Angeles")

    /* static let shared : [String:DateFormatterUtility] =
     ["America/Los_Angeles": DateFormatterUtility(identifier: "America/Los_Angeles"),
     "America/Chicago": DateFormatterUtility(identifier: "America/Chicago"),
     "America/Denver": DateFormatterUtility(identifier: "America/Denver"),
     "America/New_York": DateFormatterUtility(identifier: "America/New_York")
     ] */

    static let shared = DateFormatterUtility(identifier: "America/Los_Angeles")

    init(identifier: String) {
        update(identifier: identifier)
    }

    func update(identifier: String) {
        if preferLocalTime() {
            timeZone = .current
        } else {
            timeZone = TimeZone(identifier: identifier)
        }

        yearMonthDayTimeFormatter.timeZone = timeZone
        timezoneFormatter.timeZone = timeZone
        yearMonthDayFormatter.timeZone = timeZone
        monthDayTimeFormatter.timeZone = timeZone
        yearMonthDayNoTimeZoneTimeFormatter.timeZone = timeZone
        dayOfWeekFormatter.timeZone = timeZone
        shortDayOfMonthFormatter.timeZone = timeZone
        dayMonthDayOfWeekFormatter.timeZone = timeZone
        shortDayMonthDayTimeOfWeekFormatter.timeZone = timeZone
        dayOfWeekTimeFormatter.timeZone = timeZone
        hourMinuteTimeFormatter.timeZone = timeZone
        monthDayYearFormatter.timeZone = timeZone
    }

    func preferLocalTime() -> Bool {
        UserDefaults.standard.bool(forKey: "PreferLocalTime")
    }

    // time format
    let yearMonthDayTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "PDT")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // Current Timezone
    let timezoneFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // Year-Month-Day
    let yearMonthDayFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // Month/Day/Year
    let monthDayYearFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // UTC time format
    let monthDayTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // UTC iso8601 time format
    let iso8601Formatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // Year-Month-Day time format
    let yearMonthDayNoTimeZoneTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // DOW format
    let dayOfWeekFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    // D format
    let shortDayOfMonthFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E"
        return formatter
    }()

    // DOW format
    let dayMonthDayOfWeekFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()

    // DOW format
    let shortDayMonthDayTimeOfWeekFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EE, MMM d HH:mm"
        return formatter
    }()

    // DOW Hour:Minute time format
    let dayOfWeekTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EE HH:mm"
        return formatter
    }()

    // Hour:Minute time format
    let hourMinuteTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    func getConferenceDates(start: Date, end: Date) -> [String] {
        let calendar = NSCalendar.current
        var ret: [String] = []

        let components = calendar.dateComponents([.day], from: start, to: end)
        ret.append(yearMonthDayFormatter.string(from: start))
        var cur = start
        if components.day ?? 1 > 1 {
            for _ in 1 ... (components.day ?? 1) {
                cur = calendar.date(byAdding: Calendar.Component.day, value: 1, to: cur) ?? Date()
                ret.append(yearMonthDayFormatter.string(from: cur))
            }
        }
        return ret
    }
}

func dateSection(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "PDT")
    formatter.dateFormat = "MMMM d"
    return formatter.string(from: date)
}

func dateTabs(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "PDT")
    formatter.dateFormat = "MMM d"
    return formatter.string(from: date)
}

func tabToDate(date: String) -> Date? {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "PDT")
    formatter.dateFormat = "MMM d"
    return formatter.date(from: date)
}

func toTabId(date: String) -> String {
    let tabDate = tabToDate(date: date) ?? Date()
    return dateSection(date: tabDate)
}
