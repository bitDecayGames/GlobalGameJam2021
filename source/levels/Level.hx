package levels;

import objects.WallSegment;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {

    public var testLayer:FlxTilemap;
    public var walls:FlxSpriteGroup;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        testLayer = loader.loadTilemap(AssetPaths.test__png, "walls");

        walls = new FlxSpriteGroup();
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