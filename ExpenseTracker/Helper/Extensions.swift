import Foundation

extension Float {
    
    var formattedCurrencyText: String {
        return Utility.numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}

extension Date {
    
    func getPreviousMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    func startOfPrevMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self.getPreviousMonth())))!
    }
    
    func endOfPrevMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfPrevMonth())!
    }
    
    // Get Date Array in a certain week, offset by some day
    func datesOfWeek(weekOffset: Int = 0) -> [Date] {
        var dates = [Date]()
        for index in 1...7 {
            if let weekday = Weekday(rawValue: index) {
                let date = dateOfWeek(weekday: weekday, weekOffset: weekOffset)
                dates.append(date)
            }
        }
        return dates
    }
    
    // Get Date in a certain week, in a certain week day
    func dateOfWeek(weekday targetDayOfWeek: Weekday, weekOffset: Int = 0) -> Date {
        var selfDate = self
        let weekInterval = intervalByDays(days: weekOffset * 7)
        selfDate.addTimeInterval(weekInterval)
        
        let formattor = DateFormatter()
        formattor.timeZone = TimeZone.current
        formattor.dateFormat = "e"
        
        if let selfDayOfWeek = Int(formattor.string(from: selfDate)) {
            let interval_days = targetDayOfWeek.rawValue - selfDayOfWeek
            let interval = intervalByDays(days: interval_days)
            selfDate.addTimeInterval(interval)
            return selfDate
        }
        return selfDate
    }
    
    // for good reading
    enum Weekday: Int {
        case Sunday = 1
        case Monday = 2
        case Tuesday = 3
        case Wednesday = 4
        case Thursday = 5
        case Friday = 6
        case Saturday = 7
    }
    
    // how many seconds in a day
    private func intervalByDays(days: Int) -> TimeInterval {
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let hoursPerDay = 24
        return TimeInterval(
            days * hoursPerDay * minutesPerHour * secondsPerMinute)
    }
}
