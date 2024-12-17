import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var currentScreen: Screen

    var body: some View {
        Group {
            switch currentScreen {
            case .start:
                GameStart(currentScreen: $currentScreen)
            case .mainGame:
                MainGameView(viewModel: viewModel, currentScreen: $currentScreen)
            case .gameOver:
                GameOverView(viewModel: viewModel, currentScreen: $currentScreen)
            case .win:
                WinView(viewModel: viewModel, currentScreen: $currentScreen)
            }
        }
    }
}

