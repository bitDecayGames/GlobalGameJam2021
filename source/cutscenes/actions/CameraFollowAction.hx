package cutscenes.actions;

import flixel.math.FlxPoint;
import flixel.FlxSprite;

class CameraFollowAction extends WaitAction {
	public var actor:FlxSprite;
	public var offset:FlxPoint;

	/**
	 * Tell the camera to follow a given actor
	 * @param actor the actor for the camera to follow
	 * @param milliseconds number of milliseconds to follow, or -1 if you want it to continue following
	 * @param offset sets the camera targetOffset
	 */
	public function new(actor:FlxSprite, milliseconds:Int, ?offset:FlxPoint) {
		super(milliseconds);
		this.actor = actor;
		this.offset = offset;
	}

	override public function start() {
		super.start();
		actor.camera.followLerp = 100.0;
		actor.camera.target = actor;
		if (offset != null) {
			actor.camera.targetOffset.set(offset.x, offset.y);
		}
		// can modify the lerp here to make the camera ease into it a bit more
	}

	override function stop() {
		super.stop();
		if (milliseconds >= 0) {
			actor.camera.target = null;
			actor.camera.targetOffset.set();
		}
	}
}
