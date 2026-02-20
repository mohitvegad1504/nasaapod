import Foundation

protocol APODRepositoryProtocol {
    func fetchAPOD(for date: String?) async throws -> APODDTO
}

