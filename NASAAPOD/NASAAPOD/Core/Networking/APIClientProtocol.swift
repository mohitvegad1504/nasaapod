import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: EndPoints) async throws -> T
}
