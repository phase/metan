import Foundation
import SwiftUI
import shared

/// View for an individual Tile
struct TileView: View {
    let tile: Tile?
    let number: Int?
    let tileSize: CGFloat
    
    var body: some View {
        ZStack {
            Image(tile?.id ?? "null")
                .resizable()
                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
            Circle()
                .fill(.blue)
                .frame(width: tileSize / 4, height: tileSize / 4)
            Text(String(number ?? 0))
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
        .frame(
            // turn this tile off if it is nil
            width: tile == nil ? 0 : tileSize,
            height: tile == nil ? 0 : tileSize
        )
    }
}

/// View for a TileGrid
struct TileGridView: View {
    let tileGrid: TileGrid

    var body: some View {
        GeometryReader { geometry in
            let tiles: Int = Int(tileGrid.size)
            let maxTileWidth: Int = Int(tileGrid.maxWidth)
            let windowWidth = geometry.size.width
            let windowHeight = geometry.size.height
            let tileSize = min(windowWidth, windowHeight) / CGFloat(tiles)
            let tileOffset = tileSize * 0.75
            let hexagonWidth: CGFloat = hexagonWidth(tileSize)

            // center the board in the box
            let maxWidth = hexagonWidth * CGFloat(maxTileWidth)
            let leftOffset = (windowWidth - maxWidth) / 2
            let maxHeight = tileOffset * CGFloat(tiles) + (tileSize * 0.25)
            let topOffset = (windowHeight - maxHeight) / 2

            ForEach(0..<tiles, id: \.self) { y in
                let offsetY = tileOffset * CGFloat(y % tiles) + topOffset
                let lineOffset = (y % 2 == 0 ? 0 : hexagonWidth / 2)
                ForEach(0..<tiles, id: \.self) { x in
                    let tile = getTile(x, y)
                    let number = getNumber(x, y)
                    let offsetX = hexagonWidth * CGFloat(x % tiles) + lineOffset + leftOffset
                    TileView(tile: tile, number: number, tileSize: tileSize)
                        .offset(x: offsetX, y: offsetY)
                }
            }
        }
    }

    func hexagonWidth(_ tileSize: CGFloat) -> CGFloat {
        return (tileSize / 2) * cos(.pi / 6) * 2
    }

    /// get the id for a tile, could be "null"
    func getTile(_ x: Int, _ y: Int) -> Tile? {
        return tileGrid.tiles.get(index: Int32(y))?.get(index: Int32(x))
    }

    func getNumber(_ x: Int, _ y: Int) -> Int {
        let num: KotlinInt? = tileGrid.numbers.get(index: Int32(y))?.get(index: Int32(x))
        return (num ?? KotlinInt(integerLiteral: 0)).intValue
    }
}

struct TileGridView_Previews: PreviewProvider {
    static var previews: some View {
        let board = StandardBoardGenerator.shared.generateBoard(size: 5, tileProvider: RandomTileProvider.shared)
        TileGridView(tileGrid: board)
            .frame(width: 500, height: 500)
    }
}
