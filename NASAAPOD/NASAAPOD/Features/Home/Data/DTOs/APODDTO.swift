import Foundation

struct APODDTO: Codable, Equatable {
    let date: Date
    let title: String
    let explanation: String
    let url: String
    let mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case title
        case explanation
        case url
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let dateString = try container.decode(String.self, forKey: .date)
            guard let parsedDate = DateFormatter.apodFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .date,
                    in: container,
                    debugDescription: "Invalid date format"
                )
            }
            self.date = parsedDate
            self.title = try container.decode(String.self, forKey: .title)
            self.explanation = try container.decode(String.self, forKey: .explanation)
            self.url = try container.decode(String.self, forKey: .url)
            self.mediaType = try container.decode(String.self, forKey: .mediaType)
        }
    
    // MARK: - Computed properties
       var formattedDate: String {
           DateFormatter.displayFormatter.string(from: date)
       }
}

extension APODDTO {
    init(date: Date, title: String, explanation: String, url: String, mediaType: String) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.url = url
        self.mediaType = mediaType
    }
}
