import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedDate = Date()
    
    init() {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(repository: APODRepository(service: APODService()))
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    // MARK: - DATE PICKER
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .padding()
                    .onChange(of: selectedDate) { _, newDate in
                        let dateString = DateFormatter.apodFormatter.string(from: newDate)
                        Task {
                            await viewModel.loadAPOD(for: dateString)
                        }
                    }
                    
                    // MARK: - APOD Content
                    ScrollView {
                        VStack(spacing: 16) {
                            Color.clear.frame(height: 0).id("TOP")
                            
                            VStack(alignment: .leading, spacing: 16) {
                                switch viewModel.state {
                                    
                                case .idle:
                                    EmptyView()
                                    
                                case .loading:
                                    VStack {
                                        ProgressView("Loading APOD...")
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 300)
                                    
                                case .success(let apod):
                                    ZStack {
                                        if apod.mediaType == "video" {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 250)
                                                .cornerRadius(12)
                                            
                                            Image(systemName: "play.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white.opacity(0.8))
                                        } else {
                                            AsyncImage(url: URL(string: apod.url)) { phase in
                                                switch phase {
                                                case .empty:
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.3))
                                                        .frame(height: 250)
                                                        .overlay(ProgressView())
                                                        .cornerRadius(12)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(12)
                                                case .failure(_):
                                                    Rectangle()
                                                        .fill(Color.red.opacity(0.3))
                                                        .frame(height: 250)
                                                        .overlay(Text("Failed to load image").foregroundColor(.white))
                                                        .cornerRadius(12)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                    
                                    Text(apod.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(apod.formattedDate)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                    
                                    Text(apod.explanation)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                case .failure(let error):
                                    VStack(spacing: 12) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.orange)
                                        
                                        if let apiError = error as? APIError {
                                            Text(apiError.errorDescription)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("Something went wrong")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 300)
                                    .padding()
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("NASA APOD")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadAPOD()
            }
        }
    }
}
