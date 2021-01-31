package objects;

import states.PlayState;
import flixel.tweens.FlxTween;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxSprite;
import flixel.FlxG;
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
			PlayState.stopFollow = true;
			FlxNapeSpace.space.gravity.setxy(0, 1100);
			FlxTween.tween(FlxG.camera, {
				angle: 0.0,
			}, 0.5);
		}
	}

	public function getTriggerBody():Body {
		return null;
	}
}
