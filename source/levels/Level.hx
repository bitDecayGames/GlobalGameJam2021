package levels;

import flixel.group.FlxGroup;
import flixel.FlxBasic;
import objects.Finish;
import objects.Obstacle;
import objects.Spaceman;
import constants.CbTypes;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.nape.FlxNapeTilemap;

class Level {

    public var wallLayer:FlxNapeTilemap;
    public var objects: FlxGroup;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        var ogmoWallLayer = loader.loadTilemap(AssetPaths.test__png, "walls");

        wallLayer = new FlxNapeTilemap();
        wallLayer.loadMapFromArray(ogmoWallLayer.getData(), ogmoWallLayer.widthInTiles, ogmoWallLayer.heightInTiles, AssetPaths.test__png, 32, 32);
        wallLayer.setupTileIndices([1, 2, 3]);
        wallLayer.body.cbTypes.add(CbTypes.CB_GRABBABLE);

        objects = new FlxGroup();
		loader.loadEntities((entityData) -> {
            /*
             * entityData.name
             * entityData.x
             * entityData.y
             */
            var obj: FlxBasic;
            switch(entityData.name) {
                case "spawn":
                    obj = new Spaceman(entityData.x, entityData.y);
                case "box":
                    obj = new Obstacle(entityData.x, entityData.y);
                case "finish":
                    obj = new Finish(entityData.x, entityData.y);
                default:
                    throw entityData.name + " is not supported, please add to Level.hx";
            }
            objects.add(obj);
		}, "objects");
	}
}