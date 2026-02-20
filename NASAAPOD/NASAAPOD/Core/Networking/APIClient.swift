import Foundation


final class APIClient: APIClientProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = SSLPinningManager.shared.session) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: EndPoints) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: apiError.msg)
            } else {
                throw APIError.serverError(statusCode: httpResponse.statusCode, message: nil)
            }
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }

}

