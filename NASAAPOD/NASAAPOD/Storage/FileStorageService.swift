import Foundation

protocol FileStoring {
    func saveLatest<T: Codable>(_ object: T, fileName: String) throws
    func loadLatest<T: Codable>(_ type: T.Type, fileName: String) throws -> T?
    func delete(fileName: String) throws
}

final class FileStorageService: FileStoring {
    
    static let shared = FileStorageService()
    
    private init() {}
    
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // SAVE LATEST MODEL
    func saveLatest<T: Codable>(_ object: T, fileName: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
    
    // LOAD LATEST MODEL
    func loadLatest<T: Codable>(_ type: T.Type, fileName: String) throws -> T? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // DELETE MODEL
    func delete(fileName: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
}
