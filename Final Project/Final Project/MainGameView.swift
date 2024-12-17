import SwiftUI
struct Position: Equatable {
    var x: Int
    var y: Int
}

var size = 15

class GameViewModel: ObservableObject {
    @Published var spawn = Position(x: 2, y: 2)
    @Published var playerPosition = Position(x: 2, y: 2)
    @Published var relicPosition = Position(x: 2, y: size - 3)
    @Published var doorPosition = Position(x: 1, y: 0)
    @Published var walls: [Position] = []
    @Published var traps: [Position] = []
    @Published var toggleTraps: [Position] = []
    @Published var lives = 8
    @Published var timerRemaining = 120
    @Published var collected = false
    @Published var gameOver = false
    @Published var gameWon = false
    private var timer: Timer?
    private var trapTimer: Timer?
    
    init(){
        addWalls()
        addTraps()
        addToggles()
    }
    private func addWalls() {
        var addWall: [Position] = []
        // top wall
        for i in 0..<size {
            addWall.append(Position(x: i+2, y: 0))
        }
        // other walls
        for i in 0..<size {
            addWall.append(Position(x: 0, y: i))   // left
            addWall.append(Position(x: size - 1, y: i)) // right
            addWall.append(Position(x: i, y: size - 1)) // bottom
            
        }
        for i in 0..<size - 3{
            addWall.append(Position(x: i, y: 4))
            addWall.append(Position(x: i, y: 10))
        }
        for i in 2..<size{
            addWall.append(Position(x: i, y: 7))
        }
        walls = addWall
    }
    
    private func addTraps(){
        var addTrap: [Position] = []
        
        addTrap.append(Position(x: 4, y: 2))
        addTrap.append(Position(x: 3, y: 3))
        addTrap.append(Position(x: 8, y: 1))
        addTrap.append(Position(x: 7, y: 2))
        addTrap.append(Position(x: 6, y: 1))
        addTrap.append(Position(x: 8, y: 2))
        addTrap.append(Position(x: 4, y: 3))
        addTrap.append(Position(x: 10, y: 3))
        addTrap.append(Position(x: 11, y: 3))
        addTrap.append(Position(x: 5, y: 3))
        addTrap.append(Position(x: 11, y: 2))
        
        addTrap.append(Position(x: 5, y: 8))
        addTrap.append(Position(x: 9, y: 8))
        
        addTrap.append(Position(x: 9, y: 11))
        addTrap.append(Position(x: 9, y: 13))
        addTrap.append(Position(x: 5, y: 11))
        addTrap.append(Position(x: 5, y: 13))
        
        
        traps = addTrap
    }
    
    private func addToggles(){
        var addToggle: [Position] = []
        
        addToggle.append(Position(x: 2, y: 5))
        addToggle.append(Position(x: 3, y: 6))
        addToggle.append(Position(x: 5, y: 6))
        addToggle.append(Position(x: 5, y: 5))
        addToggle.append(Position(x: 6, y: 6))
        addToggle.append(Position(x: 6, y: 5))
        addToggle.append(Position(x: 9, y: 5))
        addToggle.append(Position(x: 9, y: 6))
        addToggle.append(Position(x: 10, y: 5))
        addToggle.append(Position(x: 10, y: 6))
        
        addToggle.append(Position(x: 3, y: 11))
        addToggle.append(Position(x: 3, y: 13))
        addToggle.append(Position(x: 4, y: 11))
        addToggle.append(Position(x: 4, y: 13))
        addToggle.append(Position(x: 6, y: 12))
        addToggle.append(Position(x: 7, y: 12))
        addToggle.append(Position(x: 9, y: 11))
        addToggle.append(Position(x: 9, y: 13))
        addToggle.append(Position(x: 10, y: 11))
        addToggle.append(Position(x: 10, y: 13))
        
        
        toggleTraps = addToggle
    }
    
    
    func startTimer() {
        // Prevent creating multiple timers
        if timer != nil || trapTimer != nil { return }
        
        // Main game countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerRemaining > 0 {
                self.timerRemaining -= 1
            } else {
                self.gameOver = true
                self.stopTimer()
            }
        }
        
        // Trap movement timer
        startTrapMovement()
    }
    
    func stopTimer() {
        timer?.invalidate()
        trapTimer?.invalidate()
        
        timer = nil
        trapTimer = nil
    }
    func startTrapMovement() {
        trapTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.moveTraps()
            self.toggle()
        }
    }
    
    private func toggle() {
        if toggleTraps.first?.x != -1{
            toggleTraps = toggleTraps.map { trap in
                return Position(x: -1, y: -1)
            }
        }
        else{
            addToggles()
            if toggleTraps.contains(playerPosition) {
                loseLife()
            }
        }
    }
    
    func loseLife(){
        lives -= 1
        playerPosition = spawn
        if lives == 0{
            gameOver = true
            stopTimer()
        }
    }
    
    private func moveTraps() {
        traps = traps.map { trap in
            
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)] // Left, Right, Up, Down
            let randomDirection = directions.randomElement()!
            let newX = trap.x + randomDirection.0
            let newY = trap.y + randomDirection.1
            let newPosition = Position(x: newX, y: newY)
            
            // prevents traps from moving onto walls
            // also partially prevents them from moving onto eachother
            if !walls.contains(newPosition) && !traps.contains(newPosition) && (3..<11).contains(newX) && (4..<size).contains(newY) {
                return newPosition
            }
            return trap
        }
        if traps.contains(playerPosition) {
            loseLife()
        }
    }
    func movePlayer(to newPosition: Position) {
        guard !walls.contains(newPosition) else { return }
        playerPosition = newPosition
        // Check for traps
        if traps.contains(newPosition) || toggleTraps.contains(newPosition) {
            loseLife()
        }
        // Check for relic collection
        if playerPosition == relicPosition {
            collected = true
            spawn = relicPosition
            relicPosition = Position(x: -1, y: -1)
        }
        // Check for win condition
        if playerPosition == doorPosition && collected {
            gameWon = true
            stopTimer()
        }
    }
    func resetGame() {
        stopTimer()
        spawn = Position(x: 2, y: 2)
        playerPosition = Position(x: 2, y: 2)
        relicPosition = Position(x: 2, y: size - 3)
        doorPosition = Position(x: 1, y: 0)
        addWalls()
        addTraps()
        addToggles()
        lives = 6
        timerRemaining = 120
        collected = false
        gameOver = false
        gameWon = false
        startTimer()
    }
}

struct MainGameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var currentScreen: Screen
    
    var body: some View {
        ZStack{
            Color(.systemGray5)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Lives: \(viewModel.lives) ")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("|  Time: \(viewModel.timerRemaining)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                GridView(rows: size, columns: size) { x, y in
                    CellView(color: cellColor(for: Position(x: x, y: y)))
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
                HStack {
                    Button("←") {
                        viewModel.movePlayer(to: Position(x: viewModel.playerPosition.x - 1, y: viewModel.playerPosition.y))
                    }
                    .buttonStyle(RoundedButtonStyle())
                    .padding()
                    VStack {
                        Button("↑") {
                            viewModel.movePlayer(to: Position(x: viewModel.playerPosition.x, y: viewModel.playerPosition.y - 1))
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .padding()
                        Button("↓") {
                            viewModel.movePlayer(to: Position(x: viewModel.playerPosition.x, y: viewModel.playerPosition.y + 1))
                        }
                        .buttonStyle(RoundedButtonStyle())
                        .padding()
                    }
                    Button("→") {
                        viewModel.movePlayer(to: Position(x: viewModel.playerPosition.x + 1, y: viewModel.playerPosition.y))
                    }
                    .buttonStyle(RoundedButtonStyle())
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onChange(of: viewModel.gameOver) { gameOver in
            if gameOver {
                currentScreen = .gameOver
            }
        }
        .onChange(of: viewModel.gameWon) { gameWon in
            if gameWon {
                currentScreen = .win
            }
        }
    }
    
    private func cellColor(for position: Position) -> Color {
        if position == viewModel.playerPosition { return .blue }
        if position == viewModel.relicPosition { return .yellow }
        if position == viewModel.doorPosition { return .gray }
        if viewModel.walls.contains(position) { return .black }
        if viewModel.traps.contains(position) && viewModel.toggleTraps.contains(position) {return .indigo}
        
        if viewModel.toggleTraps.contains(position) { return .purple }
        if viewModel.traps.contains(position) { return .red }
        
        return .white
    }
}
struct GridView<Content: View>: View {
    var rows: Int
    var columns: Int
    let content: (Int, Int) -> Content
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    content(column, row)
                        .border(Color.gray, width: 1)
                }
            }
        }
    }
}
struct CellView: View {
    let color: Color
    var body: some View {
        Rectangle()
            .fill(color)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
    }
}

struct MainGame_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = GameViewModel()
        @State var currentScreen: Screen = .mainGame
        
        MainGameView(viewModel: viewModel, currentScreen: $currentScreen)
    }
}
