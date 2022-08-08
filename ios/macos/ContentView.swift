import SwiftUI
import shared

struct Test {
    func test() {
        // we can call a method on a kotlin singleton!
        SeaTile.shared.giveResource()
        
    }
}

struct ContentView: View {
    let greet = Greeting().greeting()
    let tiles = 5
    let board = ModelKt.generateBoard(size: 5)

    var body: some View {
        VStack {
            Text(greet).padding()

            GeometryReader { geometry in
                let windowWidth = geometry.size.width
                let windowHeight = geometry.size.height
                let tileSize = min(windowWidth, windowHeight) / CGFloat(tiles)
                let hexagonWidth: CGFloat = (tileSize / 2) * cos(.pi / 6) * 2
                let spacing: CGFloat = 0
                
                ForEach(0..<tiles, id: \.self) { y in
                    ForEach(0..<tiles, id: \.self) { x in
                        let offsetX = hexagonWidth * CGFloat(x % tiles)
                         + (y % 2 == 0 ? 0 : hexagonWidth / 2 + (spacing/2))
                        let offsetY = (tileSize * 0.75) * CGFloat(y % tiles)
                        Image(getId(x: x, y: y))
                            .resizable()
                            .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                            .frame(width: tileSize, height: tileSize)
                            .offset(x: offsetX, y: offsetY)
                    }
                }
            }
        }
    }
    
    func getId(x: Int, y: Int) -> String {
        return board.tiles.get(index: Int32(y))?.get(index: Int32(x))?.id ?? "desert"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
