package cutscenes.actors;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class MovementParticle extends FlxSprite {
	public function new(posX:Float, posY:Float, secondsToLive:Float, velocity:FlxPoint) {
		super(posX, posY, AssetPaths.star_streak__png);
		health = secondsToLive;
		this.velocity.set(velocity.x, velocity.y);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		this.health -= elapsed;
		if (this.health < 0) {
			this.destroy();
		}
	}
}
