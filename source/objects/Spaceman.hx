package objects;

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

	public var leftArmUpper:Arm;
	public var leftArmLower:Arm;
	public var leftElbow:PivotJoint;

	public var rightArmUpper:Arm;
	public var rightArmLower:Arm;
	public var rightElbow:PivotJoint;

	public function new(x:Int, y:Int) {
		super();

		controls = new BasicControls();

		torso = new Torso(x, y);
		add(torso);

		leftArmUpper = new Arm(x-20, y);
		add(leftArmUpper);

		leftArmLower = new Arm(x-40, y);
		add(leftArmLower);

		leftElbow = new PivotJoint(leftArmUpper.body, leftArmLower.body, Vec2.get(-10, 0), Vec2.get(10, 0));
		leftElbow.active = true;
		leftElbow.space = FlxNapeSpace.space;

		leftShoulder = new PivotJoint(torso.body, leftArmUpper.body, Vec2.get(-10, -20), Vec2.get(10, 0));
		leftShoulder.active = true;
		leftShoulder.space = FlxNapeSpace.space;

		rightArmUpper = new Arm(x+20, y);
		add(rightArmUpper);

		rightArmLower = new Arm(x+40, y);
		add(rightArmLower);

		rightElbow = new PivotJoint(rightArmUpper.body, rightArmLower.body, Vec2.get(10, 0), Vec2.get(-10, 0));
		rightElbow.active = true;
		rightElbow.space = FlxNapeSpace.space;

		rightShoulder = new PivotJoint(torso.body, rightArmUpper.body, Vec2.get(10, -20), Vec2.get(-10, 0));
		rightShoulder.active = true;
		rightShoulder.space = FlxNapeSpace.space;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.justPressedRight) {
			trace(Vec2.get(FlxG.mouse.x, FlxG.mouse.y));
			trace(FlxNapeSpace.space.bodiesUnderPoint(Vec2.get(FlxG.mouse.x, FlxG.mouse.y), null));
		}

		if (controls.thruster.x > 0.1) {

		} else {

		}

		if (Math.abs(controls.steer.x) > 0.1) {

		} else {
		}
	}
}
