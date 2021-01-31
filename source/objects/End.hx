package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import constants.Tiles;
import nape.phys.Body;

class End extends FlxSprite implements ITargeter {
	public var triggered = false;
	public var targets: Array<ITriggerable> = [];

	public function new(x:Float, y:Float) {
		super();
		setPosition(x, y);
		makeGraphic(Tiles.Size, Tiles.Size, FlxColor.TRANSPARENT);
	}

	public function trigger() {
		if (!this.triggered) {
			triggered = true;

			// Game complete
			
		}
	}

	public function getTriggerBody():Body {
		return null;
	}
}
