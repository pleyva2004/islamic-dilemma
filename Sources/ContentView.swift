import SwiftUI

struct ContentView: View {
    @AppStorage("didFinishWalkthrough") private var didFinish = false
    @AppStorage("appearance") private var appearance = "system"   // system | light | dark

    var body: some View {
        Group {
            if didFinish {
                ExplorerView()
            } else {
                WalkthroughView(onFinish: { didFinish = true })
            }
        }
        .tint(.slate)
        .preferredColorScheme(appearance == "light" ? .light : appearance == "dark" ? .dark : nil)
    }
}


