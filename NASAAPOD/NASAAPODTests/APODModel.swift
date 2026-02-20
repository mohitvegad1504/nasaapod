import Foundation
@testable import NASAAPOD

extension APODDTO {
    
    static func mock(
        date: String = "2024-01-01",
        title: String = "Mock Title",
        explanation: String = "Mock Explanation",
        mediaType: String = "image", 
        url: String = "https://example.com/image.jpg"
    ) -> APODDTO {
        APODDTO(
            date: DateFormatter.apodFormatter.date(from: date)!,
            title: title,
            explanation: explanation,
            url: url,
            mediaType: mediaType
        )
    }
    
}
