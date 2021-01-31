package objects;

import flixel.FlxG;
import nape.constraint.AngleJoint;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.group.FlxGroup;
import nape.geom.Vec2;
import nape.constraint.PivotJoint;
import nape.shape.Circle;
import flixel.util.FlxColor;
import constants.CbTypes;
import constants.CGroups;
import constants.Tiles;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Wheel extends FlxGroup implements ITargeter {
	public var triggered = false;
	public var targets: Array<ITriggerable> = [];

	var base:FlxSprite;
	var grabber:SelfAssigningFlxNapeSprite;

	var angle:AngleJoint;
	var maxAngle =  Math.PI * 4;

	public function new(x:Float, y:Float) {
		super();


		base = new FlxSprite(x, y, AssetPaths.wheelBase__png);
		add(base);

		grabber = new GrabCircle(x, y, AssetPaths.wheel__png);
		add(grabber);

		grabber.body.userData.data = this;

		var pivot = new PivotJoint(grabber.body, FlxNapeSpace.space.world, Vec2.get(), grabber.body.localPointToWorld(Vec2.get()));
		pivot.active = true;
		pivot.space = FlxNapeSpace.space;

		angle = new AngleJoint(FlxNapeSpace.space.world, grabber.body, 0, maxAngle);
		angle.active = true;
		angle.space = FlxNapeSpace.space;
	}

	override public function update(delta:Float) {
		super.update(delta);

		base.x = grabber.x + (grabber.width / 2) - (base.width / 2);
		base.y = grabber.y + (grabber.height / 2) - (base.height / 2);

		// SFX: Wheel spinning

		if (grabber.body.rotation >= maxAngle) {
			handleRotationComplete();
		}
	}

	public function trigger() {
		// no-op
	}

	private function handleRotationComplete() {
		if (!this.triggered) {
			// Lock wheel
			angle.jointMin = maxAngle-0.05;
			triggered = true;
			for (t in this.targets) {
				t.trigger();
			}
		}
	}
}
