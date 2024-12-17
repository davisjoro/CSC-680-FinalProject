import SwiftUI

enum Screen {
    case start
    case mainGame
    case gameOver
    case win
}

import SwiftUI

@main
struct Final_ProjectApp: App {
    @StateObject private var viewModel = GameViewModel()
    @State private var currentScreen: Screen = .start

    var body: some Scene {
        WindowGroup {
            GameView(viewModel: viewModel, currentScreen: $currentScreen)
        }
    }
}
