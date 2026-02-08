import Foundation
@testable import NASAAPOD

extension APODModel {

    static func mock(
        date: String = "2024-01-01",
        title: String = "Mock Title",
        explanation: String = "Mock Explanation",
        mediaType: String = "media_type",
        url: String = "https://example.com/image.jpg"
    ) -> APODModel {
        APODModel(
            date: date,
            title: title,
            explanation: explanation,
            url: url,
            mediaType: mediaType
        )
    }
}
