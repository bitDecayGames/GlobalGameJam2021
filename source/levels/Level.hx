package levels;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.nape.FlxNapeTilemap;

class Level {

    public var wallLayer:FlxNapeTilemap;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        var ogmoWallLayer = loader.loadTilemap(AssetPaths.test__png, "walls");

        wallLayer = new FlxNapeTilemap();
        wallLayer.loadMapFromArray(ogmoWallLayer.getData(), ogmoWallLayer.heightInTiles, ogmoWallLayer.widthInTiles, AssetPaths.test__png, 32, 32);
        wallLayer.setupTileIndices([1, 2, 3]);


		// loader.loadEntities((entityData) -> {
        //     /*
        //      * entityData.name
        //      * entityData.x
        //      * entityData.y
        //      */
        //      var ws = new WallSegment(entityData.x, entityData.y);
        //      walls.add(ws);
		// }, "walls");
	}
}