package cutscenes.actions;

import flixel.FlxSprite;

class FlipAction extends Action {
	public var actor:FlxSprite;
	public var flipX:Bool;
	public var flipY:Bool;

	public function new(actor:FlxSprite, flipX:Bool, flipY:Bool) {
		super();
		this.actor = actor;
		this.flipX = flipX;
		this.flipY = flipY;
	}

	override public function start() {
		super.start();
		actor.flipX = flipX;
		actor.flipY = flipY;
		stop();
	}

	override function toString():String {
		return super.toString() + '(x:$flipX y:$flipY)';
	}
}
