package objects;

import metrics.Trackers;
import metrics.Metrics;
import com.bitdecay.analytics.Common;
import com.bitdecay.analytics.Bitlytics;
import states.CreditsState;
import haxefmod.flixel.FmodFlxUtilities;
import haxe.Timer;
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
			Bitlytics.Instance().Queue(Common.GameCompleted, 1);
			Bitlytics.Instance().Queue(Metrics.COMPLETE_TIME, Trackers.attemptTimer);

			PlayState.gameOver = true;
			FlxNapeSpace.space.gravity.setxy(0, 1100);
			FlxTween.tween(FlxG.camera, {
				angle: 0.0,
			}, 0.5, {
				onComplete: (t) -> {
					Timer.delay(() -> {
						FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
							{
								FmodFlxUtilities.TransitionToState(new CreditsState());
							});
					}, 2000);
				}
			});
		}
	}

	public function getTriggerBody():Body {
		return null;
	}
}
