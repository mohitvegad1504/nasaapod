import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {

            // Home tab
            HomeView()
                .tabItem {
                    VStack {
                        Image("icon_tab_home")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }

            // More tab
            MoreView()
                .tabItem {
                    VStack {
                        Image("icon_tab_more")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
        }
    }
}
