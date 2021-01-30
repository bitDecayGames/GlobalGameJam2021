package levels;

import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {

	public var testLayer:FlxTilemap;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        testLayer = loader.loadTilemap(AssetPaths.filler__png, "test");

		// loader.loadEntities((entityData) -> {
        //     /*
        //      * entityData.name
        //      * entityData.x
        //      * entityData.y
        //      */
		// }, "test");
	}
}