package objects;

import flixel.FlxBasic;
import nape.dynamics.InteractionFilter;
import haxe.Timer;
import flixel.math.FlxAngle;
import nape.constraint.AngleJoint;
import flixel.FlxSprite;
import haxe.Json;
import lime.utils.Assets;
import config.Validator;
import shader.Outline;
import nape.phys.Body;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionListener;
import flixel.util.FlxColor;
import nape.constraint.WeldJoint;
import nape.constraint.PivotJoint;
import nape.constraint.DistanceJoint;
import constants.CGroups;
import constants.CbTypes;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import input.BasicControls;
import nape.geom.Vec2;

class Spaceman extends FlxGroup {

	public static inline var HIP_FREEDOM = 0.5;
	public static inline var HIP_SQUAT_FREEDOM = 1;
	public static inline var KNEE_FREEDOM = 1.75;
	public static inline var KNEE_SQUAT_FREEDOM = 2.5;
	public static inline var KNEE_FLEX_OUT_RATIO = 0.33;
	public static inline var NECK_FREEDOM = 0.2;
	public static inline var HEAD_FREEDOM = 0.1;

	public static inline var ARM_EMPTY_FORCE = 5;
	public static inline var ARM_GRABBING_FORCE = 15;

	var controls:BasicControls;

	public var head:Head;
	public var neck:LimbPiece;
	public var chest:LimbPiece;
	public var cod:LimbPiece;
	public var torso:LimbPiece;

	public var chestJoint:WeldJoint;
	public var codJoint:WeldJoint;

	public var neckBody:PivotJoint;
	public var headNeck:PivotJoint;

	public var leftShoulder:PivotJoint;
	public var rightShoulder:PivotJoint;
	public var leftHip:PivotJoint;
	public var rightHip:PivotJoint;

	public var leftArmUpper:LimbPiece;
	public var leftArmLower:LimbPiece;
	public var leftHand:Hand;
	public var leftElbow:PivotJoint;
	public var leftWrist:WeldJoint;

	public var leftLegUpper:LimbPiece;
	public var leftLegLower:LimbPiece;
	public var leftFoot:Foot;
	public var leftKnee:PivotJoint;
	public var leftAnkle:WeldJoint;

	public var rightArmUpper:LimbPiece;
	public var rightArmLower:LimbPiece;
	public var rightHand:Hand;
	public var rightElbow:PivotJoint;
	public var rightWrist:WeldJoint;

	public var rightLegUpper:LimbPiece;
	public var rightLegLower:LimbPiece;
	public var rightFoot:Foot;
	public var rightKnee:PivotJoint;
	public var rightAnkle:WeldJoint;

	// map of each hand to the things it COULD grab
	var handGrabbables = new Map<Body, Array<Body>>();

	var leftHandGrabJoint:PivotJoint = null;
	var rightHandGrabJoint:PivotJoint = null;

	var leftHipLimiter:AngleJoint = null;
	var rightHipLimiter:AngleJoint = null;

	var leftKneeLimiter:AngleJoint = null;
	var rightKneeLimiter:AngleJoint = null;

	// Things for jumping
	var ankleDist:DistanceJoint = null;
	var kneeDist:DistanceJoint = null;
	var launcherDist:DistanceJoint = null;
	static inline var JUMP_JOINT_DEFAULT_DIST = 100;
	static inline var ANKLE_SQUAT_DIST = 0;
	static inline var KNEE_SQUAT_DIST = 100;
	static inline var KNEE_LAUNCH_DIST = 10;
	static inline var SQUAT_STRENGTH = 10;
	static inline var JUMP_STRENGTH = 3000;
	static inline var JUMP_TIMER = 800;

	// Needed for impulses
	var torsoLeftShoulderAnchor:Vec2 = null;
	var torsoRightShoulderAnchor:Vec2 = null;
	var extended:Bool = true;

	var outliner = new Outline(FlxColor.PURPLE, 1, 1);

	public function new(x:Float, y:Float) {
		super();

		#if !display
		// Only run this validation if we aren't running in display mode (aka auto-complete)
		Validator.validateJson("assets/data/joints.json");
		#end

		var configBytes = Assets.getBytes("assets/data/joints.json").toString();
		var jointData = Json.parse(configBytes);

		controls = new BasicControls();

		/** START LOADING BODY PARTS IN CORRECT RENDER ORDER **/
		torso = new LimbPiece(x, y, AssetPaths.torso__png, -15, -6);
		add(torso);

		rightFoot = new Foot(x, y, AssetPaths.foot_R__png);
		add(rightFoot);

		rightLegLower = new LimbPiece(x, y, AssetPaths.lowerLeg_R__png, -4);
		add(rightLegLower);

		rightLegUpper = new LimbPiece(x, y, AssetPaths.upperLeg_R__png, -4);
		add(rightLegUpper);

		leftFoot = new Foot(x, y, AssetPaths.foot_L__png);
		add(leftFoot);

		leftLegLower = new LimbPiece(x, y, AssetPaths.lowerLeg_L__png, -4);
		add(leftLegLower);


		leftLegUpper = new LimbPiece(x, y, AssetPaths.upperLeg_L__png, -4);
		add(leftLegUpper);

		// Load Neck here
		neck = new LimbPiece(x, y, AssetPaths.neck__png);
		add(neck);

		// Chest piece here
		chest = new LimbPiece(x, y, AssetPaths.chestpiece__png);
		add(chest);

		// Load Head here
		head = new Head(x, y, AssetPaths.head__png);
		add(head);

		// Cod piece here on top of legs
		cod = new LimbPiece(x, y, AssetPaths.codpiece__png);
		add(cod);

		leftArmUpper = new LimbPiece(x, y, AssetPaths.upperArm_L__png, -5);
		add(leftArmUpper);

		leftHand = new Hand(x, y, AssetPaths.handL__png);
		add(leftHand);

		leftArmLower = new LimbPiece(x, y, AssetPaths.lowerArm_L__png, -4);
		add(leftArmLower);

		rightArmUpper = new LimbPiece(x, y, AssetPaths.upperArm_R__png, -5);
		add(rightArmUpper);

		rightHand = new Hand(x, y, AssetPaths.handR__png);
		add(rightHand);

		rightArmLower = new LimbPiece(x, y, AssetPaths.lowerArm_R__png, -4);
		add(rightArmLower);
		/** END LOADING BODY PARTS IN CORRECT RENDER ORDER **/

		// allow grabbing with hands
		handGrabbables.set(leftHand.body, new Array<Body>());
		handGrabbables.set(rightHand.body, new Array<Body>());

		// BUILD TORSO

		// attach neck to torso
		neckBody = new PivotJoint(torso.body, neck.body, getAnchor(torso, jointData.player.torso.neck), getAnchor(neck, jointData.player.neck.body));
		neckBody.active = true;
		neckBody.space = FlxNapeSpace.space;
		var neckLimiter = new AngleJoint(neck.body, torso.body, -HEAD_FREEDOM, HEAD_FREEDOM);
		neckLimiter.active = true;
		neckLimiter.space = FlxNapeSpace.space;

		// attach head to neck
		headNeck = new PivotJoint(head.body, neck.body, getAnchor(head, jointData.player.head), getAnchor(neck, jointData.player.neck.head));
		headNeck.active = true;
		headNeck.space = FlxNapeSpace.space;
		var headLimiter = new AngleJoint(head.body, neck.body, -HEAD_FREEDOM, HEAD_FREEDOM);
		headLimiter.active = true;
		headLimiter.space = FlxNapeSpace.space;

		// attach chest to torso
		chestJoint = new WeldJoint(chest.body, torso.body, getAnchor(chest, jointData.player.chest), getAnchor(torso, jointData.player.torso.chest));
		chestJoint.active = true;
		chestJoint.space = FlxNapeSpace.space;

		// attach cod to torso
		codJoint = new WeldJoint(cod.body, torso.body, getAnchor(cod, jointData.player.codpiece), getAnchor(torso, jointData.player.torso.codpiece));
		codJoint.active = true;
		codJoint.space = FlxNapeSpace.space;

		// Build left arm
		leftWrist = new WeldJoint(leftHand.body, leftArmLower.body, getAnchor(leftHand, jointData.player.leftArm.hand), getAnchor(leftArmLower, jointData.player.leftArm.lower.wrist));
		leftWrist.active = true;
		leftWrist.space = FlxNapeSpace.space;

		leftElbow = new PivotJoint(leftArmUpper.body, leftArmLower.body, getAnchor(leftArmUpper, jointData.player.leftArm.upper.elbow), getAnchor(leftArmLower, jointData.player.leftArm.lower.elbow));
		leftElbow.active = true;
		leftElbow.space = FlxNapeSpace.space;

		torsoLeftShoulderAnchor = getAnchor(torso, jointData.player.torso.leftShoulder);
		leftShoulder = new PivotJoint(torso.body, leftArmUpper.body, torsoLeftShoulderAnchor.copy(), getAnchor(leftArmUpper, jointData.player.leftArm.upper.shoulder));
		leftShoulder.active = true;
		leftShoulder.space = FlxNapeSpace.space;
		// end left arm

		// Build right arm
		rightWrist = new WeldJoint(rightHand.body, rightArmLower.body, getAnchor(rightHand, jointData.player.rightArm.hand), getAnchor(rightArmLower, jointData.player.rightArm.lower.wrist));
		rightWrist.active = true;
		rightWrist.space = FlxNapeSpace.space;

		rightElbow = new PivotJoint(rightArmUpper.body, rightArmLower.body, getAnchor(rightArmUpper, jointData.player.rightArm.upper.elbow), getAnchor(rightArmLower, jointData.player.rightArm.lower.elbow));
		rightElbow.active = true;
		rightElbow.space = FlxNapeSpace.space;

		torsoRightShoulderAnchor = getAnchor(torso, jointData.player.torso.rightShoulder);
		rightShoulder = new PivotJoint(torso.body, rightArmUpper.body, torsoRightShoulderAnchor.copy(), getAnchor(rightArmUpper, jointData.player.rightArm.upper.shoulder));
		rightShoulder.active = true;
		rightShoulder.space = FlxNapeSpace.space;
		// end right arm

		// Build left leg
		leftAnkle = new WeldJoint(leftFoot.body, leftLegLower.body, getAnchor(leftFoot, jointData.player.leftLeg.foot), getAnchor(leftLegLower, jointData.player.leftLeg.lower.ankle));
		leftAnkle.active = true;
		leftAnkle.space = FlxNapeSpace.space;

		leftKnee = new PivotJoint(leftLegUpper.body, leftLegLower.body, getAnchor(leftLegUpper, jointData.player.leftLeg.upper.knee), getAnchor(leftLegLower, jointData.player.leftLeg.lower.knee));
		leftKnee.active = true;
		leftKnee.space = FlxNapeSpace.space;

		leftKneeLimiter = new AngleJoint(leftLegUpper.body, leftLegLower.body, -KNEE_FREEDOM, KNEE_FREEDOM * KNEE_FLEX_OUT_RATIO);
		leftKneeLimiter.active = true;
		leftKneeLimiter.space = FlxNapeSpace.space;

		leftHip = new PivotJoint(torso.body, leftLegUpper.body, getAnchor(torso, jointData.player.torso.leftHip), getAnchor(leftLegUpper, jointData.player.leftLeg.upper.hip));
		leftHip.active = true;
		leftHip.space = FlxNapeSpace.space;

		leftHipLimiter = new AngleJoint(torso.body, leftLegUpper.body, 0, HIP_FREEDOM);
		leftHipLimiter.active = true;
		leftHipLimiter.space = FlxNapeSpace.space;
		// end left leg

		// Build right leg
		rightAnkle = new WeldJoint(rightFoot.body, rightLegLower.body, getAnchor(rightFoot, jointData.player.rightLeg.foot), getAnchor(rightLegLower, jointData.player.rightLeg.lower.ankle));
		rightAnkle.active = true;
		rightAnkle.space = FlxNapeSpace.space;

		rightKnee = new PivotJoint(rightLegUpper.body, rightLegLower.body, getAnchor(rightLegUpper, jointData.player.rightLeg.upper.knee), getAnchor(rightLegLower, jointData.player.rightLeg.lower.knee));
		rightKnee.active = true;
		rightKnee.space = FlxNapeSpace.space;

		rightKneeLimiter = new AngleJoint(rightLegUpper.body, rightLegLower.body, -KNEE_FREEDOM * KNEE_FLEX_OUT_RATIO, KNEE_FREEDOM);
		rightKneeLimiter.active = true;
		rightKneeLimiter.space = FlxNapeSpace.space;

		rightHip = new PivotJoint(torso.body, rightLegUpper.body, getAnchor(torso, jointData.player.torso.rightHip), getAnchor(rightLegUpper, jointData.player.rightLeg.upper.hip));
		rightHip.active = true;
		rightHip.space = FlxNapeSpace.space;

		rightHipLimiter = new AngleJoint(torso.body, rightLegUpper.body, -HIP_FREEDOM, 0);
		rightHipLimiter.active = true;
		rightHipLimiter.space = FlxNapeSpace.space;
		// end right leg

		// Jump joints
		ankleDist = new DistanceJoint(
			leftFoot.body,
			rightFoot.body,
			Vec2.get(),
			Vec2.get(),
			0,
			JUMP_JOINT_DEFAULT_DIST);
		ankleDist.active = true;
		ankleDist.space = FlxNapeSpace.space;

		kneeDist = new DistanceJoint(
			leftLegUpper.body,
			rightLegUpper.body,
			getAnchor(leftLegUpper, jointData.player.leftLeg.upper.knee),
			getAnchor(rightLegUpper, jointData.player.rightLeg.upper.knee),
			0,
			JUMP_JOINT_DEFAULT_DIST);
		kneeDist.stiff = false;
		kneeDist.maxForce = 10;
		kneeDist.active = true;
		kneeDist.space = FlxNapeSpace.space;

		launcherDist = new DistanceJoint(
			torso.body,
			leftFoot.body,
			getAnchor(torso, jointData.player.torso.codpiece),
			Vec2.get(),
			0,
			150);
		launcherDist.stiff = false;
		launcherDist.maxForce = JUMP_STRENGTH;
		launcherDist.active = true;
		launcherDist.space = FlxNapeSpace.space;
		// END jump joints

		initListeners();
	}

	private function initListeners() {
		FlxNapeSpace.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbTypes.CB_HAND, CbTypes.CB_GRABBABLE,
			handToGrabbable));
		FlxNapeSpace.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, CbTypes.CB_HAND, CbTypes.CB_GRABBABLE,
			handNotGrabbable));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		#if debug
		if (FlxG.keys.pressed.W) {
			torso.body.applyImpulse(Vec2.get(0, -5, true));
		}
		if (FlxG.keys.pressed.A) {
			torso.body.applyImpulse(Vec2.get(-5, 0, true));
		}
		if (FlxG.keys.pressed.S) {
			torso.body.applyImpulse(Vec2.get(0, 5, true));
		}
		if (FlxG.keys.pressed.D) {
			torso.body.applyImpulse(Vec2.get(5, 0, true));
		}
		#end

		if (FlxG.mouse.justPressedRight) {
			trace(Vec2.get(FlxG.mouse.x, FlxG.mouse.y));
			trace(FlxNapeSpace.space.bodiesUnderPoint(Vec2.get(FlxG.mouse.x, FlxG.mouse.y), null));
		}

		var handImp = Vec2.get(controls.leftHand.x, controls.leftHand.y, true);
		handImp.rotate(-camera.angle * FlxAngle.TO_RAD);
		if (handImp.length > 0.1) {
			if (leftHandGrabJoint == null || !leftHandGrabJoint.active) {
				handImp = handImp.mul(ARM_EMPTY_FORCE);
			} else {
				handImp = handImp.mul(ARM_GRABBING_FORCE);
			}
			leftHand.body.applyImpulse(handImp);
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(torsoLeftShoulderAnchor));
		} else {
			// decay arm rotation
			var angVel = leftArmUpper.body.angularVel;
			leftArmUpper.body.applyAngularImpulse(angVel * -50);
			angVel = leftArmLower.body.angularVel;
			leftArmLower.body.applyAngularImpulse(angVel * -50);
		}

		handImp = Vec2.get(controls.rightHand.x, controls.rightHand.y, true);
		handImp.rotate(-camera.angle * FlxAngle.TO_RAD);
		if (handImp.length > 0.1) {
			if (rightHandGrabJoint == null || !rightHandGrabJoint.active) {
				handImp = handImp.mul(ARM_EMPTY_FORCE);
			} else {
				handImp = handImp.mul(ARM_GRABBING_FORCE);
			}
			rightHand.body.applyImpulse(handImp);
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(torsoRightShoulderAnchor));
		} else {
			// decay arm rotation
			var angVel = rightArmUpper.body.angularVel;
			rightArmUpper.body.applyAngularImpulse(angVel * -50);
			angVel = rightArmLower.body.angularVel;
			rightArmLower.body.applyAngularImpulse(angVel * -50);
		}

		if (controls.leftGrab.check()) {
			if (attemptGrab(leftHand.body, true)) {
				leftHand.animation.play(Hand.CLOSED_ANIM);
				FmodManager.PlaySoundOneShot(FmodSFX.Grab);
			}
		} else {
			leftHand.animation.play(Hand.OPEN_ANIM);
			if (leftHandGrabJoint != null && leftHandGrabJoint.active) {
				leftHandGrabJoint.active = false;
				FmodManager.PlaySoundOneShot(FmodSFX.Release);
			}
		}

		if (controls.rightGrab.check()) {
			if (attemptGrab(rightHand.body, false)) {
				rightHand.animation.play(Hand.CLOSED_ANIM);
				FmodManager.PlaySoundOneShot(FmodSFX.Grab);
			}
		} else {
			rightHand.animation.play(Hand.OPEN_ANIM);
			if (rightHandGrabJoint != null && rightHandGrabJoint.active) {
				rightHandGrabJoint.active = false;
				FmodManager.PlaySoundOneShot(FmodSFX.Release);
			}
		}

		if (controls.legs.check()) {
			if (extended) {
				leftHipLimiter.jointMax = HIP_SQUAT_FREEDOM;
				leftKneeLimiter.jointMin = -KNEE_SQUAT_FREEDOM;

				rightHipLimiter.jointMin = -HIP_SQUAT_FREEDOM;
				rightKneeLimiter.jointMax = KNEE_SQUAT_FREEDOM;

				ankleDist.jointMin = ANKLE_SQUAT_DIST;
				ankleDist.jointMax = ANKLE_SQUAT_DIST;
				kneeDist.jointMin = KNEE_SQUAT_DIST;
				kneeDist.jointMax = KNEE_SQUAT_DIST;
				kneeDist.maxForce = SQUAT_STRENGTH;
				launcherDist.jointMin = 50;
				launcherDist.jointMax = 50;
				extended = false;
			} else {
				extended = true;
				ankleDist.jointMin = ANKLE_SQUAT_DIST;
				ankleDist.jointMax = ANKLE_SQUAT_DIST;
				kneeDist.jointMin = KNEE_LAUNCH_DIST;
				kneeDist.jointMax = KNEE_LAUNCH_DIST;
				kneeDist.maxForce = JUMP_STRENGTH;
				launcherDist.jointMin = 100;
				launcherDist.jointMax = 100;
				Timer.delay(() -> {
					if (extended) {
						// after jumping, reset our legs to allow bending
						ankleDist.jointMin = 0;
						ankleDist.jointMax = JUMP_JOINT_DEFAULT_DIST;
						kneeDist.jointMin = 0;
						kneeDist.jointMax = JUMP_JOINT_DEFAULT_DIST;

						leftHipLimiter.jointMax = HIP_FREEDOM;
						leftKneeLimiter.jointMin = -KNEE_FREEDOM;

						rightHipLimiter.jointMin = -HIP_FREEDOM;
						rightKneeLimiter.jointMax = KNEE_FREEDOM;

						launcherDist.jointMin = 0;
						launcherDist.jointMax = 150;
					}
				}, JUMP_TIMER);
			}
		}
	}

	private function attemptGrab(hand:Body, left:Bool):Bool {
		var joint = left ? leftHandGrabJoint : rightHandGrabJoint;
		if (handGrabbables.get(hand).length > 0) {
			var grabbable = handGrabbables.get(hand)[0];
			// Trigger object if grabbable
			if (grabbable.userData != null && Std.is(grabbable.userData.data, ITriggerable)) {
				cast(grabbable.userData.data, ITriggerable).trigger();
				return true;
			}
			if (joint == null) {
				joint = new PivotJoint(hand, grabbable, Vec2.get(), grabbable.worldPointToLocal(hand.localPointToWorld(Vec2.get())));
				joint.stiff = false;
				joint.active = true;
				joint.space = FlxNapeSpace.space;
				if (left) {
					leftHandGrabJoint = joint;
				} else {
					rightHandGrabJoint = joint;
				}
				return true;
			}
			if (!joint.active) {
				joint.body1 = hand;
				joint.body2 = grabbable;
				joint.anchor1 = Vec2.get();
				joint.anchor2 = grabbable.worldPointToLocal(hand.localPointToWorld(Vec2.get()));
				joint.active = true;
				return true;
			}
		}
		return false;
	}

	private function handToGrabbable(callback:InteractionCallback) {
		if (handGrabbables.get(callback.int1.castShape.body) == null) {
			return;
		}
		if (callback.int2.isShape()) {
			handGrabbables.get(callback.int1.castShape.body).push(callback.int2.castShape.body);
		} else if (callback.int2.isBody()) {
			handGrabbables.get(callback.int1.castShape.body).push(callback.int2.castBody);
		}
	}

	private function handNotGrabbable(callback:InteractionCallback) {
		if (handGrabbables.get(callback.int1.castShape.body) == null) {
			return;
		}
		if (callback.int2.isShape()) {
			handGrabbables.get(callback.int1.castShape.body).remove(callback.int2.castShape.body);
		} else if (callback.int2.isBody()) {
			handGrabbables.get(callback.int1.castShape.body).remove(callback.int2.castBody);
		}
	}

	private function getAnchor(spr:FlxSprite, data:Dynamic):Vec2 {
		return Vec2.get(data.x - spr.width / 2, data.y - spr.height / 2);
	}
}
