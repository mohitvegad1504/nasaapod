import XCTest
@testable import NASAAPOD

// MARK: - Mock APOD Service
final class MockAPODService: APODServiceProtocol {
    var modelToReturn: APODModel?
    var errorToThrow: Error?

    func fetchAPOD(for date: String?) async throws -> APODModel {
        if let error = errorToThrow { throw error }
        if let model = modelToReturn { return model }
        throw NSError(domain: "No mock set", code: 0)
    }
}

@MainActor
final class APODRepositoryTests: XCTestCase {

    var repository: APODRepository!
    var mockService: MockAPODService!

    override func setUp() {
        mockService = MockAPODService()
        repository = APODRepository(service: mockService)
    }

    override func tearDown() {
        repository = nil
        mockService = nil
    }

    // MARK: - Test 1: Fetch succeeds
    func test_fetchAPOD_succeeds() async throws {
        let model = APODModel.mock(title: "From Network")
        mockService.modelToReturn = model

        let result = try await repository.fetchAPOD(for: "2026-02-07")

        XCTAssertEqual(result.title, "From Network")
    }

    // MARK: - Test 2: Fetch fails
    func test_fetchAPOD_fails() async {
        try? FileStorageService.shared.delete(fileName: "latest_apod.json")
        mockService.errorToThrow = NSError(domain: "Test Error", code: 0)
        do {
            _ = try await repository.fetchAPOD(for: "2026-02-07")
            XCTFail("Expected fetch to fail, but it succeeded")
        } catch {
            // Success — fetch threw an error as expected
        }
    }
}
