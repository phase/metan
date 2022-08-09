import Foundation
import SwiftUI
import shared

struct Test {
    func test() {
        // we can call a method on a kotlin singleton!
        SeaTile.shared.giveResource()
    }
}

/// View for a TileGrid
struct TileGridView: View {
    let tileGrid: TileGrid

    var body: some View {
        GeometryReader { geometry in
            let tiles: Int = Int(tileGrid.size)
            let windowWidth = geometry.size.width
            let windowHeight = geometry.size.height
            // let leftOffset = abs(windowWidth - windowHeight) / 2
            let tileSize = min(windowWidth, windowHeight) / CGFloat(tiles)
            let tileOffset = tileSize * 0.75
            let hexagonWidth: CGFloat = hexagonWidth(tileSize)

            ForEach(0..<tiles, id: \.self) { y in
                let offsetY = tileOffset * CGFloat(y % tiles)
                let lineOffset = (y % 2 == 0 ? 0 : hexagonWidth / 2)
                ForEach(0..<tiles, id: \.self) { x in
                    let offsetX = hexagonWidth * CGFloat(x % tiles) + lineOffset
                    Image(getId(x,y))
                        .resizable()
                        .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                        .frame(width: tileSize, height: tileSize)
                        .offset(x: offsetX, y: offsetY)
                }
            }
        }
    }

    func hexagonWidth(_ tileSize: CGFloat) -> CGFloat {
        return (tileSize / 2) * cos(.pi / 6) * 2
    }

    /// get the id for a tile, could be "null"
    // TODO: handle null tiles properly
    func getId(_ x: Int, _ y: Int) -> String {
        return tileGrid.get(x: Int32(x), y: Int32(y))?.id ?? "null"
    }
}

struct TileGridView_Previews: PreviewProvider {
    static var previews: some View {
        let board = StandardBoardGenerator.shared.generateBoard(size: 5, tileProvider: RandomTileProvider.shared)
        TileGridView(tileGrid: board)
    }
}
