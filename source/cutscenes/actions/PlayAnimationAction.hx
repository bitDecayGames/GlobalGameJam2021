package cutscenes.actions;

import flixel.FlxSprite;
import cutscenes.Action;

class PlayAnimationAction extends Action {
	public var actor:FlxSprite;
	public var animationName:String;
	public var waitUntilAnimationIsFinished:Bool;

	public function new(actor:FlxSprite, animationName:String, waitUntilAnimationIsFinished:Bool) {
		super();
		this.actor = actor;
		this.animationName = animationName;
		this.waitUntilAnimationIsFinished = waitUntilAnimationIsFinished;
	}

	override public function start() {
		super.start();
		var hasAnimation = actor.animation.getByName(animationName) != null;
		if (hasAnimation) {
			if (waitUntilAnimationIsFinished) {
				actor.animation.finishCallback = onAnimationFinish;
			} else {
				stop();
			}
			actor.animation.play(animationName);
		} else {
			stop();
		}
	}

	private function onAnimationFinish(animationName:String):Void {
		if (waitUntilAnimationIsFinished && animationName == this.animationName) {
			stop();
		}
	}

	override function toString():String {
		return super.toString() + '($animationName)';
	}
}
