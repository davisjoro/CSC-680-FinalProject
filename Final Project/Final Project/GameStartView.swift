import SwiftUI

struct GameStart: View {
    @Binding var currentScreen: Screen

    var body: some View {
        ZStack{
            Color(red: 0.8, green: 0.8, blue: 0.8)
                .ignoresSafeArea()
            VStack {
                Text("Treasure Escape")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                Image("Treasure")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding()
                Button("Start") {
                    currentScreen = .mainGame
                }
                .fontWeight(.bold)
                .font(.system(size: 23))
                .padding()
            }
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        @State var currentScreen: Screen = .start

        // Return the preview
        GameStart(currentScreen: $currentScreen)
    }
}

