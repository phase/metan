package io.jadon.metan.model

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
    override val id: String = "sea"
}

class TileGrid(val size: Int = 5) {
    val tiles = Array(size) { arrayOfNulls<Tile>(size) }
}

fun generateBoard(size: Int = 5): TileGrid {
    val possibleTiles = listOf(
        FieldTile,
        PastureTile,
        MountainTile,
        ForestTile,
        HillTile,
        DesertTile,
    )
    return TileGrid(size).apply {
        (0 until size).forEach { y ->
            (0 until size).forEach { x ->
                tiles[y][x] = possibleTiles[Random.Default.nextInt(possibleTiles.size)]
            }
        }
    }
}
