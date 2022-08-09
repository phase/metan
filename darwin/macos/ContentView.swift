import SwiftUI
import shared

struct ContentView: View {
    let greet = Greeting().greeting()
    let board = StandardBoardGenerator.shared.generateBoard(size: 5, tileProvider: RandomTileProvider.shared)

    var body: some View {
        VStack {
            Text(greet).padding()

            TileGridView(tileGrid: board)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
