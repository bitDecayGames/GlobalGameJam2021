package levels;

import flixel.FlxSprite;
import checkpoint.CheckpointManager;
import flixel.tile.FlxTilemap;
import flixel.math.FlxVector;
import objects.SelfAssigningFlxNapeSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxBasic;
import objects.Ball;
import objects.Button;
import objects.Blackout;
import objects.Checkpoint;
import objects.Door;
import objects.Lever;
import objects.Obstacle;
import objects.Spaceman;
import objects.Wheel;
import objects.ITriggerable;
import objects.ITargeter;
import constants.CbTypes;
import constants.Tiles;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.nape.FlxNapeTilemap;

class Level {

    public var player:Spaceman;

    public var wallLayer:FlxNapeTilemap;
    public var background1:FlxTilemap;
    public var background2:FlxTilemap;
    public var objects: FlxGroup;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        var ogmoWallLayer = loader.loadTilemap(AssetPaths.interiorGreen__png, "walls");
        background1 = loader.loadTilemap(AssetPaths.interiorGrey__png, "background");
        background2 = loader.loadTilemap(AssetPaths.backgroundGrey__png, "background");

        wallLayer = new FlxNapeTilemap();
        wallLayer.loadMapFromArray(ogmoWallLayer.getData(), ogmoWallLayer.widthInTiles, ogmoWallLayer.heightInTiles, AssetPaths.interiorGreen__png, Tiles.Size, Tiles.Size);
        // First 4 tiles are empty
        wallLayer.setupTileIndices([for (i in 4...ogmoWallLayer.totalTiles - 1) i]);
        wallLayer.body.cbTypes.add(CbTypes.CB_GRABBABLE);
        wallLayer.body.cbTypes.add(CbTypes.CB_BUMPER);

        objects = new FlxGroup();
        var needsTarget = new Map<String, ITargeter>();
        var needsTargeting = new Map<String, ITriggerable>();

		loader.loadEntities((entityData) -> {
            var rot = entityData.rotation != null ? entityData.rotation : 0.0;

            var posDelta = new FlxVector(
                entityData.width != null ? entityData.width / 2 : 0,
                entityData.height != null ? entityData.height / 2 : 0
            );
            posDelta.rotateByRadians(rot);

            var x = entityData.x + posDelta.x;
            var y = entityData.y + posDelta.y;

            var obj: FlxBasic;
            switch(entityData.name) {
                case "spawn":
                    if (!CheckpointManager.firstTime) {
                        CheckpointManager.setCheckpoint(x, y);
                    }
                    player = new Spaceman(CheckpointManager.getX(), CheckpointManager.getY());
                    obj = player;
                case "box":
                    obj = new Obstacle(x, y);
                case "door":
                    obj = new Door(x, y);
                case "button":
                    obj = new Button(x, y);
                case "ball":
                    obj = new Ball(x, y);
                case "checkpoint":
                    obj = new Checkpoint(x, y);
                case "lever":
                    obj = new Lever(x, y);
                case "wheel":
                    obj = new Wheel(x, y);
                case "blackout":
                    if (entityData.width == null) {
                        throw "blackout missing width";
                    }
                    if (entityData.height == null) {
                        throw "blackout missing height";
                    }
                    obj = new Blackout(entityData.x, entityData.y, entityData.width, entityData.height);

                default:
                    throw entityData.name + " is not supported, please add to Level.hx";
            }
            objects.add(obj);

            if (Std.is(obj, SelfAssigningFlxNapeSprite)) {
                var fOb = cast(obj, SelfAssigningFlxNapeSprite);
                var space = fOb.body.space;
                fOb.body.space = null;
                fOb.body.rotation = rot;
                fOb.body.space = space;
            }

            if (entityData.values == null) {
                return;
            }

            // Set up triggers and targets
            var targets = entityData.values.targets;
            if (targets != null) {
                var targetter = cast(obj, ITargeter);
                var targetStrList = Std.string(targets).split(",");

                for (ts in targetStrList) {
                    needsTarget.set(ts, targetter);

                    if (needsTargeting.exists(ts)) {
                        targetter.targets.push(cast(needsTargeting.get(ts), ITriggerable));
                    }
                }
            }
            var targetValue = entityData.values.targetValue;
            if (targetValue != null) {
                var triggerable = cast(obj, ITriggerable);
                needsTargeting.set(targetValue, triggerable);

                if (needsTarget.exists(targetValue)) {
                    cast(needsTarget.get(targetValue), ITargeter).targets.push(triggerable);
                }
            }
		}, "objects");
	}
}