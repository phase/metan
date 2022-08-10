import Foundation
import SwiftUI
import shared

func hexagonWidth(_ tileSize: CGFloat) -> CGFloat {
    return (tileSize / 2) * cos(.pi / 6) * 2
}

struct IntersectionView: View {
    let tileView: TileView
    var body: some View {
        Circle()
            .opacity(0)
            .allowsHitTesting(true)
            .onTapGesture {
                tileView.flag = !tileView.flag
            }
    }
}

struct HexagonImageView: View {
    let imageId: String
    var body: some View {
        Image(imageId)
            .resizable()
            .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
    }
}

struct NumberView: View {
    let number: Int
    let color: Color
    let circleSize: CGFloat
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: circleSize, height: circleSize)
        Text(String(number))
            .foregroundColor(.white)
            .shadow(radius: 5)
    }
}

/// View for an individual Tile
struct TileView: View {
    let tile: Tile?
    let number: Int?
    let tileSize: CGFloat
    @State var flag: Bool = true
    
    var body: some View {
        ZStack {
            HexagonImageView(imageId: tile?.id ?? "desert")
            NumberView(
                number: number ?? 0,
                color: flag ? .blue : .red,
                circleSize: tileSize / 4
            )

            // build intersections
            let intersections = 12
            ForEach(0..<intersections, id: \.self) { i in
                let angle = angle(i, intersections)
                let offsetX = CGFloat(cos(angle) * tileSize / 2)
                let offsetY = CGFloat(sin(angle) * hexagonWidth(tileSize) / 2)
                IntersectionView(tileView: self)
                    .offset(x:offsetX, y: offsetY)
                    .frame(width: tileSize / 4, height: tileSize / 4)
            }
        }
        .frame(
            // turn this tile off if it is nil
            width: tile == nil ? 0 : tileSize,
            height: tile == nil ? 0 : tileSize
        )
    }
    
    func angle(_ i: Int, _ sides: Int) -> Double {
        return (Double(i) * (360.0 / Double(sides))) * Double.pi / 180
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
        .drawingGroup()
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
