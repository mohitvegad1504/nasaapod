import XCTest
@testable import NASAAPOD

@MainActor
final class FileStorageServiceTests: XCTestCase {

    private let fileStorage = FileStorageService.shared
    private let testFileName = "test_apod.json"

    override func setUp() async throws {
        try? fileStorage.delete(fileName: testFileName)
    }

    // MARK: - Test 2
    func test_loadLatest_whenFileDoesNotExist_returnsNil() throws {
        // Arrange
        let nonExistingFileName = "non_existing_file.json"
        
        // Act
        let result = try fileStorage.loadLatest(APODDTO.self, fileName: nonExistingFileName)
        
        // Assert
        XCTAssertNil(result, "Expected nil when file does not exist")
    }

}
