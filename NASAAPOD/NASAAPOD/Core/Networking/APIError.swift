import Foundation

struct APIErrorResponse: Decodable {
    let code: Int
    let msg: String
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(_, let message):
            return message ?? "Server error occurred"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

