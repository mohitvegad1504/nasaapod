import Foundation

extension DateFormatter {
    
    static let apodFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.calendar = Calendar(identifier: .gregorian)
           formatter.locale = Locale.current
           formatter.timeZone = TimeZone.current
           formatter.dateFormat = "dd MMM yyyy" 
           return formatter
       }()
}
