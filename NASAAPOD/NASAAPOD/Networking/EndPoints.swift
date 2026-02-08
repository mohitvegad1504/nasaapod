import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


enum EndpointError: Error {
    case missingAPIKey
    case invalidURL
    var errorDescription: String? {
          switch self {
          case .missingAPIKey: return "NASA API key is missing in Secrets.plist"
          case .invalidURL: return "Failed to create a valid URL for APOD endpoint"
          }
      }
}

struct EndPoints {
    let url: URL
    let method: HTTPMethod
    
    // MARK: - NASA APOD
    static func getAPOD(date: String? = nil) throws -> EndPoints {
        //  Get API key
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = dict["NASA_API_KEY"] as? String else {
            print(EndpointError.missingAPIKey.errorDescription ?? "Unknown error")
            throw EndpointError.missingAPIKey
        }
        
        // Build URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = "/planetary/apod"
        
        var queryItems = [URLQueryItem(name: "api_key", value: key)]
        if let date = date {
            queryItems.append(URLQueryItem(name: "date", value: date))
        }
        components.queryItems = queryItems
        
        guard let finalURL = components.url else {
            print(EndpointError.invalidURL.errorDescription ?? "Unknown error")
            throw EndpointError.invalidURL
        }
        
        return EndPoints(url: finalURL, method: .get)
    }
}
