package io.jadon.metan.model

import kotlin.math.abs
import kotlin.math.floor
import kotlin.random.Random

interface Resource

object WheatResource : Resource
object SheepResource : Resource
object RockResource : Resource
object WoodResource : Resource
object BrickResource : Resource

interface Tile {
    val id: String
    fun giveResource(): List<Resource> = listOf()
}

object FieldTile : Tile {
    override val id: String = "field"
}
object PastureTile : Tile{
    override val id: String = "pasture"
}
object MountainTile : Tile {
    override val id: String = "mountain"
}
object ForestTile : Tile {
    override val id: String = "forest"
}
object HillTile : Tile {
    override val id: String = "hill"
}
object DesertTile : Tile {
    override val id: String = "desert"
}
object SeaTile : Tile {
    // TODO: get image for this
    override val id: String = "sea"
}

class TileGrid(val size: Int = STANDARD_BOARD_SIZE) {
    val tiles = Array(size) { arrayOfNulls<Tile>(size) }

    fun get(x: Int, y: Int) = tiles[y][x]

    override fun toString(): String {
       return tiles.joinToString("\n") {
            it.joinToString(" ") {
                if (it == null) " " else "x"
            }
        }
    }
}

const val STANDARD_BOARD_SIZE = 5
val possibleTiles = listOf(
    FieldTile,
    PastureTile,
    MountainTile,
    ForestTile,
    HillTile,
    DesertTile,
)

interface TileProvider {
    fun getNextTile(): Tile
}

object RandomTileProvider : TileProvider {
    override fun getNextTile(): Tile = possibleTiles[Random.Default.nextInt(possibleTiles.size)]
}

interface TileGridGenerator {
    fun generateBoard(size: Int, tileProvider: TileProvider): TileGrid
}

object StandardBoardGenerator : TileGridGenerator {
    override fun generateBoard(size: Int, tileProvider: TileProvider): TileGrid {
        val height = if (size % 2 == 0) size + 1 else size
        val half = floor(height.toFloat() / 2.0f)
        val middleIsEven = half.toInt() % 2 == 0
        return TileGrid(height).apply {
            (0 until height).forEach { y ->
                val yIsEven = y % 2 == 0
                val dy = abs(floor((abs(y - half)) / 2)).toInt()
                val max = floor(size.toDouble() - dy).toInt()
                // account for even lines getting offset because everything is hexagons
                val end = max - if (!yIsEven && middleIsEven) 1 else 0
                val start = dy + if (yIsEven && !middleIsEven) 1 else 0
                (start until end).forEach { x ->
                    // how far away it is from the middle tile
                    tiles[y][x] = tileProvider.getNextTile()
                }
            }
        }
    }
}

object SquareBoardGenerator : TileGridGenerator {
    override fun generateBoard(size: Int, tileProvider: TileProvider): TileGrid {
        return TileGrid(size).apply {
            (0 until size).forEach { y ->
                (0 until size).forEach { x ->
                    tiles[y][x] = tileProvider.getNextTile()
                }
            }
        }
    }
}
