import SwiftUI
import shared

struct ContentView: View {
    let greet = Greeting().greeting()
    let board = ModelKt.generateBoard(size: 4)

    var body: some View {
        VStack {
            Text(greet).padding()

            TileGridView(tileGrid: board)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
