package objects;

import shader.Outline;
import nape.phys.Body;
import haxe.DynamicAccess;
import flixel.FlxObject;
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
	var controls:BasicControls;

	public var torso:Torso;
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
	public var leftFoot:Hand;
	public var leftKnee:PivotJoint;
	public var leftAnkle:WeldJoint;

	public var rightArmUpper:LimbPiece;
	public var rightArmLower:LimbPiece;
	public var rightHand:Hand;
	public var rightElbow:PivotJoint;
	public var rightWrist:WeldJoint;

	public var rightLegUpper:LimbPiece;
	public var rightLegLower:LimbPiece;
	public var rightFoot:Hand;
	public var rightKnee:PivotJoint;
	public var rightAnkle:WeldJoint;

	// map of each hand to the things it COULD grab
	var handGrabbables = new Map<Body, Array<Body>>();

	var leftHandGrabJoint:PivotJoint = null;
	var rightHandGrabJoint:PivotJoint = null;

	var torsoLeftShoulderAnchor = Vec2.get(-23, -28);
	var torsoRightShoulderAnchor = Vec2.get(23, -28);
	var torsoLeftHipAnchor = Vec2.get(-15, 36);
	var torsoRightHipAnchor = Vec2.get(15, 36);

	var upperShoulderAnchor = Vec2.get(0, -17);
	var upperElbowAnchor = Vec2.get(0, 18);

	var lowerElbowAnchor = Vec2.get(0, -17);
	var lowerWristAnchor = Vec2.get(0, 18);

	var upperHipAnchor = Vec2.get(0, -23);
	var upperKneeAnchor = Vec2.get(0, 25);

	var lowerKneeAnchor = Vec2.get(0, -22);
	var lowerAnkleAnchor = Vec2.get(0, 26);

	var ankleAnchor = Vec2.get(0, 0);

	var wristAnchor = Vec2.get(0,0);

	var outliner = new Outline(FlxColor.PURPLE, 1, 1);

	public function new(x:Int, y:Int) {
		super();

		controls = new BasicControls();

		torso = new Torso(x, y);
		torso.shader = outliner;
		add(torso);

		leftArmUpper = new LimbPiece(x, y, AssetPaths.upperArm_L__png);
		leftArmUpper.shader = outliner;
		add(leftArmUpper);

		leftArmLower = new LimbPiece(x, y, AssetPaths.lowerArm_L__png);
		add(leftArmLower);

		leftHand = new Hand(x, y);
		add(leftHand);

		handGrabbables.set(leftHand.body, new Array<Body>());

		leftWrist = new WeldJoint(leftHand.body, leftArmLower.body, wristAnchor.copy(), lowerWristAnchor.copy());
		leftWrist.active = true;
		leftWrist.space = FlxNapeSpace.space;

		leftElbow = new PivotJoint(leftArmUpper.body, leftArmLower.body, upperElbowAnchor.copy(), lowerElbowAnchor.copy());
		leftElbow.active = true;
		leftElbow.space = FlxNapeSpace.space;

		leftHip = new PivotJoint(torso.body, leftArmUpper.body, torsoLeftShoulderAnchor.copy(), upperShoulderAnchor.copy());
		leftHip.active = true;
		leftHip.space = FlxNapeSpace.space;

		rightArmUpper = new LimbPiece(x, y, AssetPaths.upperArm_R__png);
		add(rightArmUpper);

		rightArmLower = new LimbPiece(x, y, AssetPaths.lowerArm_R__png);
		add(rightArmLower);

		rightHand = new Hand(x, y);
		add(rightHand);

		handGrabbables.set(rightHand.body, new Array<Body>());

		rightWrist = new WeldJoint(rightHand.body, rightArmLower.body, wristAnchor.copy(), lowerWristAnchor.copy());
		rightWrist.active = true;
		rightWrist.space = FlxNapeSpace.space;

		rightElbow = new PivotJoint(rightArmUpper.body, rightArmLower.body, upperElbowAnchor.copy(), lowerElbowAnchor.copy());
		rightElbow.active = true;
		rightElbow.space = FlxNapeSpace.space;

		rightShoulder = new PivotJoint(torso.body, rightArmUpper.body, torsoRightShoulderAnchor.copy(), upperShoulderAnchor.copy());
		rightShoulder.active = true;
		rightShoulder.space = FlxNapeSpace.space;

		leftLegUpper = new LimbPiece(x, y, AssetPaths.upperLeg_L__png);
		leftLegUpper.shader = outliner;
		add(leftLegUpper);

		leftLegLower = new LimbPiece(x, y, AssetPaths.lowerLeg_L__png);
		add(leftLegLower);

		leftFoot = new Hand(x, y);
		add(leftFoot);

		leftAnkle = new WeldJoint(leftFoot.body, leftLegLower.body, ankleAnchor.copy(), lowerAnkleAnchor.copy());
		leftAnkle.active = true;
		leftAnkle.space = FlxNapeSpace.space;

		leftKnee = new PivotJoint(leftLegUpper.body, leftLegLower.body, upperKneeAnchor.copy(), lowerKneeAnchor.copy());
		leftKnee.active = true;
		leftKnee.space = FlxNapeSpace.space;

		leftHip = new PivotJoint(torso.body, leftLegUpper.body, torsoLeftHipAnchor.copy(), upperHipAnchor.copy());
		leftHip.active = true;
		leftHip.space = FlxNapeSpace.space;

		rightLegUpper = new LimbPiece(x, y, AssetPaths.upperLeg_R__png);
		rightLegUpper.shader = outliner;
		add(rightLegUpper);

		rightLegLower = new LimbPiece(x, y, AssetPaths.lowerLeg_R__png);
		add(rightLegLower);

		rightFoot = new Hand(x, y);
		add(rightFoot);

		rightAnkle = new WeldJoint(rightFoot.body, rightLegLower.body, ankleAnchor.copy(), lowerAnkleAnchor.copy());
		rightAnkle.active = true;
		rightAnkle.space = FlxNapeSpace.space;

		rightKnee = new PivotJoint(rightLegUpper.body, rightLegLower.body, upperKneeAnchor.copy(), lowerKneeAnchor.copy());
		rightKnee.active = true;
		rightKnee.space = FlxNapeSpace.space;

		rightHip = new PivotJoint(torso.body, rightLegUpper.body, torsoRightHipAnchor.copy(), upperHipAnchor.copy());
		rightHip.active = true;
		rightHip.space = FlxNapeSpace.space;

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

		if (FlxG.mouse.justPressedRight) {
			trace(Vec2.get(FlxG.mouse.x, FlxG.mouse.y));
			trace(FlxNapeSpace.space.bodiesUnderPoint(Vec2.get(FlxG.mouse.x, FlxG.mouse.y), null));
		}

		var handImp = Vec2.get(controls.leftHand.x, controls.leftHand.y, true);
		if (handImp.length > 0.1) {
			handImp = handImp.mul(30);
			FlxG.watch.addQuick("Left Hand: ", handImp);
			leftHand.body.applyImpulse(handImp);
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(torsoLeftShoulderAnchor));
		}

		handImp = Vec2.get(controls.rightHand.x, controls.rightHand.y, true);
		if (handImp.length > 0.1) {
			handImp = handImp.mul(30);
			FlxG.watch.addQuick("Right Hand: ", handImp);
			rightHand.body.applyImpulse(handImp);
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(torsoRightShoulderAnchor));
		}

		if (controls.leftGrab.check()) {
			leftHand.color = FlxColor.GRAY;
			attemptGrab(leftHand.body, true);
		} else {
			leftHand.color = FlxColor.WHITE;
			if (leftHandGrabJoint != null) {
				leftHandGrabJoint.active = false;
			}
		}

		if (controls.rightGrab.check()) {
			rightHand.color = FlxColor.GRAY;
			attemptGrab(rightHand.body, false);
		} else {
			rightHand.color = FlxColor.WHITE;
			if (rightHandGrabJoint != null) {
				rightHandGrabJoint.active = false;
			}
		}
	}

	private function attemptGrab(hand:Body, left:Bool) {
		var joint = left ? leftHandGrabJoint : rightHandGrabJoint;
		if (handGrabbables.get(hand).length > 0) {
			var grabbable = handGrabbables.get(hand)[0];
			if (joint == null) {
				joint = new PivotJoint(hand, grabbable, Vec2.get(), grabbable.worldPointToLocal(hand.localPointToWorld(Vec2.get())));
				FmodManager.PlaySoundOneShot(FmodSFX.Grab);
				joint.active = true;
				joint.space = FlxNapeSpace.space;
				if (left) {
					leftHandGrabJoint = joint;
				} else {
					rightHandGrabJoint = joint;
				}
			}
			if (!joint.active) {
				joint.body1 = hand;
				joint.body2 = grabbable;
				joint.anchor1 = Vec2.get();
				joint.anchor2 = grabbable.worldPointToLocal(hand.position);
				joint.active = true;
				FmodManager.PlaySoundOneShot(FmodSFX.Grab);
			}
		}
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
}
