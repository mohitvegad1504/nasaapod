import Foundation

protocol APODServiceProtocol {
    func fetchAPOD(for date: String?) async throws -> APODDTO
}
