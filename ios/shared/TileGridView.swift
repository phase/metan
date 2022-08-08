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
            let tileSize = min(windowWidth, windowHeight) / CGFloat(tiles)
            let tileOffset = tileSize * 0.75
            let hexagonWidth: CGFloat = hexagonWidth(tileSize)

            ForEach(0..<tiles, id: \.self) { y in
                ForEach(0..<tiles, id: \.self) { x in
                    let offsetX = hexagonWidth * CGFloat(x % tiles)
                     + (y % 2 == 0 ? 0 : hexagonWidth / 2)
                    let offsetY = tileOffset * CGFloat(y % tiles)
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
    
    func getId(_ x: Int, _ y: Int) -> String {
        return tileGrid.tiles.get(index: Int32(y))?.get(index: Int32(x))?.id ?? "desert"
    }
}
