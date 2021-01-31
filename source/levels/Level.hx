package levels;

import flixel.group.FlxGroup;
import flixel.FlxBasic;
import objects.Button;
import objects.Door;
import objects.Finish;
import objects.Obstacle;
import objects.Spaceman;
import objects.ITriggerable;
import objects.ITargeter;
import constants.CbTypes;
import constants.Tiles;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.nape.FlxNapeTilemap;

class Level {

    public var wallLayer:FlxNapeTilemap;
    public var objects: FlxGroup;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        var ogmoWallLayer = loader.loadTilemap(AssetPaths.interiorGreen__png, "walls");

        wallLayer = new FlxNapeTilemap();
        wallLayer.loadMapFromArray(ogmoWallLayer.getData(), ogmoWallLayer.widthInTiles, ogmoWallLayer.heightInTiles, AssetPaths.interiorGreen__png, Tiles.Size, Tiles.Size);
        // First tile is empty
        wallLayer.setupTileIndices([for (i in 4...ogmoWallLayer.totalTiles - 1) i]);
        wallLayer.body.cbTypes.add(CbTypes.CB_GRABBABLE);

        objects = new FlxGroup();
        var needsTarget = new Map<String, ITargeter>();
        var needsTargeting = new Map<String, ITriggerable>();
		loader.loadEntities((entityData) -> {
            var obj: FlxBasic;
            switch(entityData.name) {
                case "spawn":
                    obj = new Spaceman(entityData.x, entityData.y);
                case "box":
                    obj = new Obstacle(entityData.x, entityData.y);
                case "finish":
                    obj = new Finish(entityData.x, entityData.y);
                case "door":
                    obj = new Door(entityData.x, entityData.y);
                case "button":
                    obj = new Button(entityData.x, entityData.y);
                default:
                    throw entityData.name + " is not supported, please add to Level.hx";
            }
            objects.add(obj);

            if (entityData.values == null) {
                return;
            }

            // Set up triggers and targets
            var target = entityData.values.target;
            if (target != null) {
                var targetter = cast(obj, ITargeter);
                if (needsTargeting.exists(target)) {
                    targetter.target = cast(needsTargeting[target], ITriggerable);
                } else {
                    needsTarget[target] = targetter;
                }
            }
            var targetValue = entityData.values.targetValue;
            if (targetValue != null) {
                var triggerable = cast(obj, ITriggerable);
                if (needsTarget.exists(targetValue)) {
                    cast(needsTarget[targetValue], ITargeter).target = triggerable;
                } else {
                    needsTargeting[targetValue] = triggerable;
                }
            }
		}, "objects");
	}
}