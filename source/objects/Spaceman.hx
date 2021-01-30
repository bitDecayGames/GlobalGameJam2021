package objects;

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
	public var leftShoulderAnchor:Vec2;
	public var rightShoulderAnchor:Vec2;

	public var leftArmUpper:Arm;
	public var leftArmLower:Arm;
	public var leftHand:Hand;
	public var leftElbow:PivotJoint;
	public var leftWrist:WeldJoint;

	public var rightArmUpper:Arm;
	public var rightArmLower:Arm;
	public var rightHand:Hand;
	public var rightElbow:PivotJoint;
	public var rightWrist:WeldJoint;

	// map of each hand to the things it COULD grab
	var handGrabbables = new Map<Body, Array<Body>>();

	var leftHandGrabJoint:PivotJoint = null;
	var rightHandGrabJoint:PivotJoint = null;

	public function new(x:Int, y:Int) {
		super();

		controls = new BasicControls();

		torso = new Torso(x, y);
		add(torso);

		leftArmUpper = new Arm(x - 20, y);
		add(leftArmUpper);

		leftArmLower = new Arm(x - 40, y);
		add(leftArmLower);

		leftHand = new Hand(x - 60, y);
		add(leftHand);

		handGrabbables.set(leftHand.body, new Array<Body>());

		leftWrist = new WeldJoint(leftHand.body, leftArmLower.body, Vec2.get(), Vec2.get(-10, 0));
		leftWrist.active = true;
		leftWrist.space = FlxNapeSpace.space;

		leftElbow = new PivotJoint(leftArmUpper.body, leftArmLower.body, Vec2.get(-10, 0), Vec2.get(10, 0));
		leftElbow.active = true;
		leftElbow.space = FlxNapeSpace.space;

		leftShoulderAnchor = Vec2.get(-10, -20);
		leftShoulder = new PivotJoint(torso.body, leftArmUpper.body, leftShoulderAnchor, Vec2.get(10, 0));
		leftShoulder.active = true;
		leftShoulder.space = FlxNapeSpace.space;

		rightArmUpper = new Arm(x + 20, y);
		add(rightArmUpper);

		rightArmLower = new Arm(x + 40, y);
		add(rightArmLower);

		rightHand = new Hand(x + 60, y);
		add(rightHand);

		handGrabbables.set(rightHand.body, new Array<Body>());

		rightWrist = new WeldJoint(rightHand.body, rightArmLower.body, Vec2.get(), Vec2.get(10, 0));
		rightWrist.active = true;
		rightWrist.space = FlxNapeSpace.space;

		rightElbow = new PivotJoint(rightArmUpper.body, rightArmLower.body, Vec2.get(10, 0), Vec2.get(-10, 0));
		rightElbow.active = true;
		rightElbow.space = FlxNapeSpace.space;

		rightShoulderAnchor = Vec2.get(10, -20);
		rightShoulder = new PivotJoint(torso.body, rightArmUpper.body, rightShoulderAnchor, Vec2.get(-10, 0));
		rightShoulder.active = true;
		rightShoulder.space = FlxNapeSpace.space;

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
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(leftShoulderAnchor));
		}

		handImp = Vec2.get(controls.rightHand.x, controls.rightHand.y, true);
		if (handImp.length > 0.1) {
			handImp = handImp.mul(30);
			FlxG.watch.addQuick("Right Hand: ", handImp);
			rightHand.body.applyImpulse(handImp);
			torso.body.applyImpulse(handImp.mul(-1), torso.body.localPointToWorld(rightShoulderAnchor));
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
			}
		}
	}

	private function handToGrabbable(callback:InteractionCallback) {
		handGrabbables.get(callback.int1.castShape.body).push(callback.int2.castShape.body);
	}

	private function handNotGrabbable(callback:InteractionCallback) {
		handGrabbables.get(callback.int1.castShape.body).remove(callback.int2.castShape.body);
	}
}
