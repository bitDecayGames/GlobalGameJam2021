package cutscenes.scenes;

import flixel.FlxState;
import flixel.FlxSprite;
import cutscenes.actions.WaitAction;
import cutscenes.actions.StartMusicAction;
import cutscenes.actions.PlaySfxAction;
import cutscenes.actions.StopMusicAction;
import cutscenes.actions.PlayAnimationAction;
import cutscenes.actions.MoveAction;
import cutscenes.actions.CameraFollowAction;
import cutscenes.actions.SpinAction;
import cutscenes.actions.TriggerAction;
import cutscenes.actions.WrapperAction;
import cutscenes.actions.FlipAction;
import cutscenes.actors.OriginalMajorTom;
import cutscenes.actors.OriginalTeleBall;

/**
 * This is a copy of the end cutscene from EventfulHorizon
 */
class GroundControlToMajorTomScene extends Cutscene {
	public function new(state:FlxState) {
		super();
		var majorTom = new OriginalMajorTom();
		var teleBall = new OriginalTeleBall();
		var levelBackground = new FlxSprite(0, 0, AssetPaths.OriginalFinalLevel__png);
		state.add(levelBackground);
		state.add(majorTom);
		state.add(teleBall);

		var startingActions = new StartMusicAction(FmodSongs.LetsGo); // change to Space Oddity song
		startingActions.add(new CameraFollowAction(majorTom, -1)); // start by following tom but don't block
		startingActions.add(new TriggerAction(() -> {
			// set up the starting position of the actors
			majorTom.setPosition(100, 300);
			majorTom.angle = 0;
			teleBall.setPosition(100, 300);
			teleBall.visible = false;
			teleBall.angle = 0;
			levelBackground.setPosition(20, 280);

			camera.zoom = 3.0;
		}));
		add(startingActions);
		add(new PlayAnimationAction(majorTom, "stand", false));
		add(new WaitAction(1000));
		add(new FlipAction(majorTom, true, false));
		add(new WaitAction(1000));
		add(new FlipAction(majorTom, false, false));
		add(new WaitAction(1000));
		add(new FlipAction(majorTom, true, false));
		add(new WaitAction(1000));
		add(new FlipAction(majorTom, false, false));
		add(new WaitAction(500));
		add(new PlayAnimationAction(majorTom, "slow-aim", true));
		add(new PlayAnimationAction(majorTom, "slow-throw-start", true));
		add(new TriggerAction(() -> {
			teleBall.visible = true;
			teleBall.setPosition(majorTom.x + 10, majorTom.y - 5);
		}));
		add(new PlayAnimationAction(teleBall, "slow-blink", false));
		add(new PlayAnimationAction(majorTom, "slow-throw-finish", false));
		add(new WrapperAction((builder) -> {
			var teleballMoveAction = new WaitAction(8000);
			teleballMoveAction.add(new MoveAction(teleBall, teleBall.getPosition(), teleBall.getPosition().add(100, -25), teleballMoveAction.milliseconds));
			teleballMoveAction.add(new CameraFollowAction(teleBall, teleballMoveAction.milliseconds));
			teleballMoveAction.add(new SpinAction(teleBall, 50, teleballMoveAction.milliseconds, false));

			var innerCutscene = new Cutscene();
			innerCutscene.add(new WaitAction(6000));
			innerCutscene.add(new PlayAnimationAction(majorTom, "teleport-out", true));
			innerCutscene.add(new TriggerAction(() -> {
				majorTom.visible = false;
			}));
			teleballMoveAction.add(innerCutscene);
			return teleballMoveAction;
		}));
		add(new TriggerAction(() -> {
			teleBall.visible = false;
			majorTom.visible = true;
			majorTom.setPosition(teleBall.x, teleBall.y);
		}));
		add(new PlaySfxAction(FmodSFX.MenuHover));
		add(new PlayAnimationAction(majorTom, "teleport-in-fall", false));
		add(new WrapperAction((builder) -> {
			var tomSpinAction = new MoveAction(majorTom, majorTom.getPosition(), majorTom.getPosition().add(100, -25), 8000);
			tomSpinAction.add(new CameraFollowAction(majorTom, tomSpinAction.milliseconds));
			tomSpinAction.add(new SpinAction(majorTom, 10, tomSpinAction.milliseconds, false));
			return tomSpinAction;
		}));
		add(new StopMusicAction());
	}
}
