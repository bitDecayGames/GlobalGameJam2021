package objects;

import nape.constraint.WeldJoint;
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

class Lever extends FlxGroup implements ITargeter {
	public var triggered = false;
	public var targets: Array<ITriggerable> = [];

	var base:FlxSprite;
	var puller:SelfAssigningFlxNapeSprite;

	var angle:AngleJoint;
	var maxAngle = -((Math.PI / 4) + 0.2);

	public function new(x:Float, y:Float) {
		super();

		puller = new GrabRect(x, y, AssetPaths.lever__png, -8, -15);
		add(puller);

		base = new FlxSprite(x, y, AssetPaths.leverBase__png);
		add(base);

		puller.body.userData.data = this;

		var pivot = new PivotJoint(puller.body, FlxNapeSpace.space.world, getAnchor(7, 115), puller.body.localPointToWorld(getAnchor(7, 115)));
		pivot.active = true;
		pivot.space = FlxNapeSpace.space;

		angle = new AngleJoint(FlxNapeSpace.space.world, puller.body, maxAngle, 0);
		angle.active = true;
		angle.space = FlxNapeSpace.space;
	}

	var aligned = false;

	override public function update(delta:Float) {
		super.update(delta);

		if (!aligned) {
			aligned = true;
			base.x = puller.x + (puller.width / 2) - (base.width / 2) + 7;
			base.y = puller.y + puller.height - base.height;
		}
		if (puller.body.rotation <= maxAngle) {
			handleRotationComplete();
		}
	}

	public function trigger() {
		// no-op
	}

	private function handleRotationComplete() {
		if (!this.triggered) {
			triggered = true;

			// Lock lever
			angle.jointMin = maxAngle;
			angle.jointMax = maxAngle;
			angle.stiff = true;

			// SFX: Play satisfying clunk of lever being engaged

			for (t in targets) {
				t.trigger();
			}
		}
	}

	private function getAnchor(x:Float, y:Float):Vec2 {
		return Vec2.get(x - puller.width / 2, y - puller.height / 2);
	}
}
