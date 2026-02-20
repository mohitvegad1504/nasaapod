import Foundation

final class APODService: APODServiceProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchAPOD(for date: String? = nil) async throws -> APODDTO {
        try await apiClient.request(endpoint: EndPoints.getAPOD(date: date))
    }
}
