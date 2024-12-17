import SwiftUI

struct WinView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var currentScreen: Screen

    var body: some View {
        ZStack{
            Color(red: 0.55, green: 0.9, blue: 0.55)
                .ignoresSafeArea()
            VStack {
                Text("You Win!")
                    .font(.system(size: 75))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding()
                Image("Victory")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding()
                Text("Nice work")
                    .font(.system(size: 25))
                    .padding()
                Button("Restart") {
                    viewModel.resetGame()
                    currentScreen = .mainGame
                }
                .font(.system(size: 25))
                .fontDesign(.rounded)
                .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.8))
                .padding()
                Button("Start Screen") {
                    viewModel.resetGame()
                    currentScreen = .start
                }
                .font(.system(size: 25))
                .fontDesign(.rounded)
                .padding()
            }
        }
    }
}

struct WinView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock view model
        let viewModel = GameViewModel()
        // Create a dummy screen binding
        @State var currentScreen: Screen = .win

        // Return the preview
        WinView(viewModel: viewModel, currentScreen: $currentScreen)
    }
}
