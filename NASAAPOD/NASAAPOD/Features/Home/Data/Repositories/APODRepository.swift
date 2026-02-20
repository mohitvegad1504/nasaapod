import Foundation

final class APODRepository: APODRepositoryProtocol {
    
    private let service: APODServiceProtocol
    private let fileStorage: FileStoring 
    private let cacheFileName = "latest_apod.json"
    
    init(service: APODServiceProtocol, fileStorage: FileStoring = FileStorageService.shared) {
        self.service = service
        self.fileStorage = fileStorage
    }
    
    func fetchAPOD(for date: String? = nil) async throws -> APODDTO {
        do {
            let response = try await service.fetchAPOD(for: date)
            try? fileStorage.saveLatest(response, fileName: cacheFileName)
            return response
        } catch {
            if let cachedModel: APODDTO = try? fileStorage.loadLatest(APODDTO.self, fileName: cacheFileName) {
                return cachedModel
            } else {
                throw error
            }
        }
    }
}
