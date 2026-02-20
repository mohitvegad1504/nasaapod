import Foundation
import Combine

enum ViewState<Value> {
    case idle
    case loading
    case success(Value)
    case failure(Error)
}

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var state: ViewState<APODDTO> = .idle
    private var loadTask: Task<Void, Never>?
    
    private let repository: APODRepositoryProtocol
    
    // MARK: - Initialization
    init(repository: APODRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Method
    
    func loadAPOD(for date: String? = nil) async {
        let dateString = date ?? DateFormatter.apodFormatter.string(from: Date())
        loadTask?.cancel()
            state = .loading
            loadTask = Task { [weak self] in
                guard let self else { return }
                do {
                    let response = try await self.repository.fetchAPOD(for: dateString)
                    guard !Task.isCancelled else { return }
                    self.state = .success(response)
                } catch is CancellationError {
                } catch {
                    guard !Task.isCancelled else { return }
                    self.state = .failure(error)
                }
            }
        }

        deinit {
            loadTask?.cancel()
        }
    
}
