package objects;

import nape.phys.Body;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Blackout extends FlxSprite implements ITriggerable {
	public var triggered = false;

	public function new(x:Float, y:Float, w:Int, h:Int) {
		super();
		setPosition(x, y);
		makeGraphic(w, h, FlxColor.BLACK);
	}

	public function trigger() {
		if (!triggered) {
			triggered = true;
			FlxTween.tween(this, {alpha: 0}, 1, { onComplete: (t) -> this.kill()});

			// SFX: "Reveal" sound effect for new room uncovered
		}
	}

	public function getTriggerBody():Body {
		return null;
	}
}
