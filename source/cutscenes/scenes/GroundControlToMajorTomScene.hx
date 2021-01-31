package cutscenes.scenes;

import flixel.addons.display.FlxBackdrop;
import states.CreditsState;
import flixel.FlxG;
import haxefmod.flixel.FmodFlxUtilities;
import states.PlayState;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import cutscenes.actions.WaitAction;
import cutscenes.actions.StartMusicAction;
import cutscenes.actions.PlaySfxAction;
import cutscenes.actions.StopMusicAction;
import cutscenes.actions.PlayAnimationAction;
import cutscenes.actions.MoveAction;
import cutscenes.actions.CameraFollowAction;
import cutscenes.actions.SpinAction;
import cutscenes.actions.TriggerAction;
import cutscenes.actions.IntervalAction;
import cutscenes.actions.WrapperAction;
import cutscenes.actions.FlipAction;
import cutscenes.actions.ZoomCameraAction;
import cutscenes.actors.OriginalMajorTom;
import cutscenes.actors.OriginalTeleBall;
import cutscenes.actors.OriginalLevelPlatforms;
import cutscenes.actors.FarAwaySpaceShip;
import cutscenes.actors.MovementParticle;
import cutscenes.actors.TitleText1;
import cutscenes.actors.TitleText2;
import helpers.UiHelpers;

/**
 * This is a copy of the end cutscene from EventfulHorizon
 */
class GroundControlToMajorTomScene extends Cutscene {
	private var rnd = new FlxRandom();

	public function new(state:FlxState) {
		super();
		var majorTom = new OriginalMajorTom();
		var teleBall = new OriginalTeleBall();
		var levelBackground = new OriginalLevelPlatforms();
		var farAwaySpaceShip = new FarAwaySpaceShip();
		var titleText1 = new TitleText1();
		var titleText2 = new TitleText2();
		var backdrop = new FlxBackdrop(AssetPaths.nebula0__png, 0, 0);
		backdrop.x -= backdrop.width * 0.5;
		backdrop.y -= backdrop.height * 0.5;
		state.add(backdrop);
		state.add(levelBackground);
		state.add(farAwaySpaceShip);
		state.add(majorTom);
		state.add(teleBall);
		state.add(titleText1);
		state.add(titleText2);
		var startBtn = UiHelpers.createMenuButton("Start", () -> {
			FmodFlxUtilities.TransitionToStateAndStopMusic(new PlayState(AssetPaths.main_level__json));
		});
		startBtn.setPosition(FlxG.width / 2 - startBtn.width / 2, FlxG.height - startBtn.height - 70);
		startBtn.updateHitbox();
		state.add(startBtn);

		var creditsBtn = UiHelpers.createMenuButton("Credits", () -> {
			FmodFlxUtilities.TransitionToState(new CreditsState());
		});
		creditsBtn.setPosition(FlxG.width / 2 - creditsBtn.width / 2, FlxG.height - creditsBtn.height - 40);
		creditsBtn.updateHitbox();
		state.add(creditsBtn);

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
			farAwaySpaceShip.setPosition(400, 200);
			titleText1.visible = false;
			titleText2.visible = false;
			startBtn.exists = false;
			creditsBtn.exists = false;

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
		add(new PlaySfxAction(FmodSFX.MenuHover)); // TODO: FX teleport ball popping
		add(new PlayAnimationAction(majorTom, "teleport-in-fall", false));
		add(new WrapperAction((builder) -> {
			var tomPos = majorTom.getPosition();
			var tomNewPos = majorTom.getPosition().add(100, -25);
			var shipNewPos = new FlxPoint(tomNewPos.x, tomNewPos.y).add(0, -50);

			var tomSpinAction = new MoveAction(majorTom, tomPos, tomNewPos, 8000);
			tomSpinAction.add(new CameraFollowAction(majorTom, tomSpinAction.milliseconds));
			tomSpinAction.add(new SpinAction(majorTom, 10, tomSpinAction.milliseconds, false));
			tomSpinAction.add(new MoveAction(farAwaySpaceShip, farAwaySpaceShip.getPosition(), shipNewPos, tomSpinAction.milliseconds));
			return tomSpinAction;
		}));
		add(new TriggerAction(() -> {
			levelBackground.visible = false;
		}));
		add(new WrapperAction((builder) -> {
			var shipPos = farAwaySpaceShip.getPosition();
			var shipNewPos = new FlxPoint(shipPos.x, shipPos.y).add(-400, 0);

			var shipSlamIntoTomAction = new MoveAction(farAwaySpaceShip, shipPos, shipNewPos, 4000);
			shipSlamIntoTomAction.add(new CameraFollowAction(majorTom, shipSlamIntoTomAction.milliseconds));
			shipSlamIntoTomAction.add(new SpinAction(majorTom, 10, shipSlamIntoTomAction.milliseconds, false));
			return shipSlamIntoTomAction;
		}));
		add(new IntervalAction(150, 4000, () -> {
			var x = farAwaySpaceShip.x - 150;
			var y = farAwaySpaceShip.y;
			var secondsToLive = 3.0;
			var velocity = new FlxPoint(400, 0);
			state.add(new MovementParticle(x, rnd.float(-1, 1) * 100 + y, secondsToLive, velocity));
		}));
		add(new WrapperAction((builder) -> {
			var tomPos = majorTom.getPosition();
			var shipPos = farAwaySpaceShip.getPosition();
			var diff = -800;
			var tomNewPos = new FlxPoint(tomPos.x + diff, tomPos.y);
			var shipNewPos = new FlxPoint(shipPos.x + diff, shipPos.y);

			var moveOffscreen = new MoveAction(majorTom, tomPos, tomNewPos, 4000);
			moveOffscreen.add(new MoveAction(farAwaySpaceShip, shipPos, shipNewPos, moveOffscreen.milliseconds));
			moveOffscreen.add(new ZoomCameraAction(1, Std.int(moveOffscreen.milliseconds)));
			return moveOffscreen;
		}));
		add(new TriggerAction(() -> {
			majorTom.visible = false;
			farAwaySpaceShip.visible = false;
			titleText1.visible = true;
			titleText2.visible = true;

			majorTom.setPosition(0, 0);
			camera.target = majorTom;
			camera.zoom = 2;

			titleText1.setPosition(600 - titleText1.width * .5, -titleText1.height * .5);
			titleText2.setPosition(600 - titleText2.width * .5, -titleText2.height * .5);
		}));
		add(new WrapperAction((builder) -> {
			var moveOnScreen = new MoveAction(titleText1, titleText1.getPosition(), titleText1.getPosition().add(-600, 0), 4000);
			return moveOnScreen;
		}));
		add(new WaitAction(3000));
		add(new WrapperAction((builder) -> {
			var moveOnScreen = new MoveAction(titleText1, titleText1.getPosition(), titleText1.getPosition().add(-600), 4000);
			moveOnScreen.add(new MoveAction(titleText2, titleText2.getPosition(), titleText2.getPosition().add(-600, 0), moveOnScreen.milliseconds));
			return moveOnScreen;
		}));
		add(new WaitAction(2000));
		add(new TriggerAction(() -> {
			startBtn.exists = true;
			creditsBtn.exists = true;
		}));
		add(new WrapperAction((builder) -> {
			var moveCameraDown = new MoveAction(majorTom, majorTom.getPosition(), majorTom.getPosition().add(0, 100), 2000);
			moveCameraDown.add(new ZoomCameraAction(1, moveCameraDown.milliseconds));
			return moveCameraDown;
		}));
		add(new StopMusicAction());
	}
}
