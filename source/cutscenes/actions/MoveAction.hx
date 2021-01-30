package cutscenes.actions;

import flixel.tweens.motion.LinearMotion;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import cutscenes.Action;

class MoveAction extends Action {
	public var actor:FlxSprite;
	public var startPos:FlxPoint;
	public var endPos:FlxPoint;
	public var milliseconds:Int;

	private var tween:LinearMotion;

	public function new(actor:FlxSprite, startPos:FlxPoint, endPos:FlxPoint, milliseconds:Int) {
		super();
		this.actor = actor;
		this.startPos = startPos;
		this.endPos = endPos;
		this.milliseconds = milliseconds;
	}

	override public function start() {
		super.start();
		tween = FlxTween.linearMotion(actor, startPos.x, startPos.y, endPos.x, endPos.y, milliseconds / 1000.0, true);
		tween.start();
		tween.onComplete = (_) -> {
			if (tween != null) {
				tween.destroy();
				tween = null;
			}
			stop();
		};
	}

	override function stop() {
		super.stop();
		if (tween != null) {
			tween.cancel();
			tween.destroy();
			tween = null;
		}
	}
}
