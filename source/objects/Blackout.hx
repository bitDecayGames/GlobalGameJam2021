package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Blackout extends FlxSprite implements ITriggerable {
	public var triggered = false;

	public function new(x:Int, y:Int, w:Int, h:Int) {
		super();
		setPosition(x, y);
		makeGraphic(w, h, FlxColor.BLACK);
	}

	public function trigger() {
		triggered = true;
		this.kill();
	}
}
