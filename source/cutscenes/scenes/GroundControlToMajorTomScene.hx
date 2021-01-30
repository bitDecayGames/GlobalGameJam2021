package cutscenes.scenes;

import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import cutscenes.actions.WaitAction;
import cutscenes.actions.StartMusicAction;
import cutscenes.actions.StopMusicAction;
import cutscenes.actions.PlayAnimationAction;
import cutscenes.actions.MoveAction;
import cutscenes.actions.CameraFollowAction;
import cutscenes.actions.SpinAction;
import cutscenes.actions.TriggerAction;

/**
 * This is a copy of the end cutscene from EventfulHorizon
 */
class GroundControlToMajorTomScene extends Cutscene {
	public function new(state:FlxState) {
		super();
		var majorTom:FlxSprite = new FlxSprite(100, 300);
		majorTom.makeGraphic(30, 60, FlxColor.GREEN);
		var teleBall:FlxSprite = new FlxSprite(100, 300);
		teleBall.makeGraphic(20, 20, FlxColor.LIME);

		teleBall.visible = false;
		state.add(majorTom);
		state.add(teleBall);

		var startingActions = new StartMusicAction(FmodSongs.LetsGo); // change to Space Oddity song
		startingActions.add(new CameraFollowAction(majorTom, -1)); // start by following tom but don't block
		add(startingActions);
		add(new WaitAction(2000));
		add(new PlayAnimationAction(majorTom, "slow-turn", true));
		add(new PlayAnimationAction(majorTom, "slow-throw", true));
		add(new TriggerAction(() -> {
			teleBall.visible = true;
		}));
		var teleballMoveAction = new MoveAction(teleBall, majorTom.getPosition(), majorTom.getPosition().add(200, -100), 4000);
		teleballMoveAction.add(new CameraFollowAction(teleBall, teleballMoveAction.milliseconds));
		teleballMoveAction.add(new SpinAction(teleBall, 50, teleballMoveAction.milliseconds, false));
		add(teleballMoveAction);
		add(new PlayAnimationAction(teleBall, "explode", true));
		add(new TriggerAction(() -> {
			teleBall.visible = false;
			majorTom.setPosition(teleBall.x, teleBall.y);

			// having this inside another action trigger is sketchy, but maybe it won't be a problem?
			var tomSpinAction = new MoveAction(majorTom, majorTom.getPosition(), majorTom.getPosition().add(200, -100), 5000);
			tomSpinAction.add(new CameraFollowAction(majorTom, tomSpinAction.milliseconds));
			tomSpinAction.add(new SpinAction(majorTom, 10, tomSpinAction.milliseconds, false));
			add(tomSpinAction);
			add(new StopMusicAction());
		}));
	}
}
