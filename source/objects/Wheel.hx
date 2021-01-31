package objects;

import flixel.math.FlxAngle;
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

	var increments = new Map<Body, Float>();

	var base:FlxSprite;
	var grabber:SelfAssigningFlxNapeSprite;

	var angle:AngleJoint;
	var maxAngle =  Math.PI * 4;
	var lastSqueakAngle:Float = 0;

	var locked:Bool = false;
	var lockedClickAng:Float = 0;

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

		var angVel = grabber.body.angularVel;
		if (angVel > 0.1) {
			grabber.body.applyAngularImpulse(angVel * -10);
			angVel = grabber.body.angularVel;
			grabber.body.applyAngularImpulse(angVel * -10);

			// SFX: Wheel spinning 
			var currentAng = FlxAngle.TO_DEG*grabber.body.rotation;
			if (!locked && Math.abs(currentAng-lastSqueakAngle) > 72){
				lastSqueakAngle = currentAng;
				FmodManager.PlaySoundOneShot(FmodSFX.Squeak);
			}

			FlxG.watch.addQuick("Current Angle: ", grabber.body.rotation);
			FlxG.watch.addQuick("Joint Min: ", angle.jointMin);
			FlxG.watch.addQuick("Joint Max: ", angle.jointMax);

			if (locked && (grabber.body.rotation == angle.jointMin || currentAng == angle.jointMax)){
				if (lockedClickAng != grabber.body.rotation) {
					FmodManager.PlaySoundOneShot(FmodSFX.HandleComplete);
					lockedClickAng = grabber.body.rotation;
				}
			}
		} 

		if (!triggered) {
			var ratio = grabber.body.rotation / maxAngle;
			for (t in this.targets) {
				var b = t.getTriggerBody();
				if (b != null) {
					if (!increments.exists(b)) {
						increments.set(b, b.position.x);
					}

					b.position.x = increments.get(b) + b.userData.data.height * ratio;
				}
			}
		}

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

			// SFX: Wheen lock sound / door opened fully sound
			FmodManager.PlaySoundOneShot(FmodSFX.HandleLock);

			angle.jointMin = maxAngle-0.5;
			locked = true;
			triggered = true;
			for (t in this.targets) {
				t.trigger();
			}
		}
	}

	public function getTriggerBody():Body {
		return grabber.body;
	}
}
