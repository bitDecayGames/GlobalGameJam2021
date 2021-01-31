package objects;

import nape.phys.Body;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import constants.Tiles;
import checkpoint.CheckpointManager;

class Checkpoint extends FlxSprite implements ITriggerable {
	public var triggered = false;

	public function new(x:Float, y:Float) {
		super();
		setPosition(x, y);
		makeGraphic(Tiles.Size, Tiles.Size, FlxColor.TRANSPARENT);
	}

	public function trigger() {
		if (!this.triggered) {
			this.triggered = true;
			CheckpointManager.setCheckpoint(this.x, this.y);
		}
	}

	public function getTriggerBody():Body {
		return null;
	}
}
