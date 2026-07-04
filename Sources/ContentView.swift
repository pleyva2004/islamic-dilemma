import SwiftUI

struct ContentView: View {
    @AppStorage("didFinishWalkthrough") private var didFinish = false

    var body: some View {
        Group {
            if didFinish {
                ExplorerView()
            } else {
                WalkthroughView(onFinish: { didFinish = true })
            }
        }
        .tint(.slate)
    }
}


