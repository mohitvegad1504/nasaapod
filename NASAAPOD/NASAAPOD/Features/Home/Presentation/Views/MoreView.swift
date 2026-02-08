import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            Color.clear
                .navigationTitle("More")
                .ignoresSafeArea(.all, edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
