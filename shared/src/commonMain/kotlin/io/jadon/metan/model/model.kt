package io.jadon.metan.model

import kotlin.math.abs
import kotlin.math.floor
import kotlin.random.Random

interface Board {
    val tileGrid: TileGrid
}

interface ResourceHolder {
    val resources: List<Resource>

    fun hasResource(target: Resource, amount: Int = 1): Boolean {
        var foundAmount = 0
        for (resource in resources) {
            if (resource == target) {
                foundAmount++
            }
        }
        return foundAmount >= amount
    }
}

// piece that collects resources, like a settlement or city
interface ResourceCollector {
    val collectionMultiplier: Int
}

// piece that provides resources, like a tile
interface ResourceProvider {
    val resource: Resource

    fun giveResource(collector: ResourceCollector): Array<Resource> = emptyArray()
}

interface Recipe {
    val requiredMaterials: Array<Pair<Resource, Int>>

    fun canPurchase(player: ResourceHolder): Boolean {
        return !requiredMaterials.map { player.hasResource(it.first, it.second) }.contains(false)
    }
}

object Road : Recipe {
    override val requiredMaterials = arrayOf(
        Pair(WoodResource, 1),
        Pair(BrickResource, 1),
    )
}

object Settlement : Recipe, ResourceCollector {
    override val requiredMaterials = arrayOf(
        Pair(WheatResource, 1),
        Pair(SheepResource, 1),
        Pair(WoodResource, 1),
        Pair(RockResource, 1),
    )
    override val collectionMultiplier: Int = 1
}

object City : Recipe, ResourceCollector {
    override val requiredMaterials = arrayOf(
        Pair(WheatResource, 2),
        Pair(RockResource, 3),
    )
    override val collectionMultiplier: Int = 2
}

object DevelopmentCard : Recipe {
    override val requiredMaterials = arrayOf(
        Pair(WheatResource, 1),
        Pair(RockResource, 1),
        Pair(SheepResource, 1),
    )
}

interface Resource

object WheatResource : Resource
object SheepResource : Resource
object RockResource : Resource
object WoodResource : Resource
object BrickResource : Resource

interface Tile {
    // used for images in darwin targets
    val id: String
}

interface ResourceTile: Tile, ResourceProvider {
    override fun giveResource(collector: ResourceCollector): Array<Resource> {
        return Array(collector.collectionMultiplier) { resource }
    }
}

object FieldTile : ResourceTile {
    override val id: String = "field"
    override val resource: Resource = WheatResource
}
object PastureTile : ResourceTile {
    override val id: String = "pasture"
    override val resource: Resource = SheepResource
}
object MountainTile : ResourceTile {
    override val id: String = "mountain"
    override val resource: Resource = RockResource
}
object ForestTile : ResourceTile {
    override val id: String = "forest"
    override val resource: Resource = WoodResource
}
object HillTile : ResourceTile {
    override val id: String = "hill"
    override val resource: Resource = BrickResource
}
object DesertTile : Tile {
    override val id: String = "desert"
}
object SeaTile : Tile {
    // TODO: get image for this
    override val id: String = "sea"
}

data class TileGrid(val size: Int = STANDARD_BOARD_SIZE, val maxWidth: Int = size) {
    val tiles = Array(size) { arrayOfNulls<Tile>(size) }
    val numbers = Array(size) { Array(size) { Random.Default.nextInt(2, 13) } }

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
    fun nextTile(): Tile
}

object RandomTileProvider : TileProvider {
    override fun nextTile(): Tile = possibleTiles[Random.Default.nextInt(possibleTiles.size)]
}

interface TileGridGenerator {
    fun generateBoard(size: Int, tileProvider: TileProvider): TileGrid
}

/// standard hexagon board
object StandardBoardGenerator : TileGridGenerator {
    override fun generateBoard(size: Int, tileProvider: TileProvider): TileGrid {
        val height = if (size % 2 == 0) size + 1 else size
        val half = floor(height.toFloat() / 2.0f)
        val middleIsEven = half.toInt() % 2 == 0
        return TileGrid(height, maxWidth = size).apply {
            (0 until height).forEach { y ->
                val yIsEven = y % 2 == 0
                val dy = abs(floor((abs(y - half)) / 2)).toInt()
                val max = floor(size.toDouble() - dy).toInt()
                // account for even lines getting offset because everything is hexagons
                val end = max - if (!yIsEven && middleIsEven) 1 else 0
                val start = dy + if (yIsEven && !middleIsEven) 1 else 0
                (start until end).forEach { x ->
                    // how far away it is from the middle tile
                    tiles[y][x] = tileProvider.nextTile()
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
                    tiles[y][x] = tileProvider.nextTile()
                }
            }
        }
    }
}
