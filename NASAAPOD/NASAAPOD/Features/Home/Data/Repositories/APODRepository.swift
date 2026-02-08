import Foundation

final class APODRepository: APODRepositoryProtocol {
    
    private let service: APODServiceProtocol
    private let fileStorage: FileStoring 
    private let cacheFileName = "latest_apod.json"
    
    init(service: APODServiceProtocol, fileStorage: FileStoring = FileStorageService.shared) {
        self.service = service
        self.fileStorage = fileStorage
    }
    
    func fetchAPOD(for date: String? = nil) async throws -> APODModel {
        do {
            let response = try await service.fetchAPOD(for: date)
            try? fileStorage.saveLatest(response, fileName: cacheFileName)
            return response
        } catch {
            if let cachedModel: APODModel = try? fileStorage.loadLatest(APODModel.self, fileName: cacheFileName) {
                return cachedModel
            } else {
                throw error
            }
        }
    }
}
