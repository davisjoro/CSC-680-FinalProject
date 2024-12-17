import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var currentScreen: Screen

    var body: some View {
        ZStack{
            Color(red:0.5, green: 0.2, blue: 0.2)
                .ignoresSafeArea()
            VStack {
                Text("You Lose")
                    .font(.system(size: 75))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding()
                
                Image("Skull")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding()
                Text("You ran out of lives or time.")
                    .font(.system(size: 21))
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding()
                
                Button("Restart") {
                    viewModel.resetGame()
                    currentScreen = .mainGame
                }
                
                .fontDesign(.rounded)
                .font(.system(size: 25))
                .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.6))
                .padding()
                Button("Start Screen") {
                    viewModel.resetGame()
                    currentScreen = .start
                }
                .font(.system(size: 25))
                .padding()
                .fontDesign(.rounded)
            }
        }
    }
}

struct GameOver_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock view model
        let viewModel = GameViewModel()
        // Create a dummy screen binding
        @State var currentScreen: Screen = .gameOver

        // Return the preview
        GameOverView(viewModel: viewModel, currentScreen: $currentScreen)
    }
}
