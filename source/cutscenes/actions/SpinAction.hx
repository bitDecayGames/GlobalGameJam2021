package cutscenes.actions;

import flixel.FlxSprite;

class SpinAction extends WaitAction {
	public var actor:FlxSprite;
	public var rpm:Float;
	public var clockwise:Bool;

	private var initialAngle:Float;
	private var totalAngleRevolutions:Float;

	public function new(actor:FlxSprite, rpm:Float, milliseconds:Int, clockwise:Bool = true) {
		super(milliseconds);
		this.actor = actor;
		this.rpm = rpm;
		this.clockwise = clockwise;
		initialAngle = actor.angle;
	}

	override public function start() {
		super.start();
		actor.angle = initialAngle;
		totalAngleRevolutions = (rpm * (milliseconds / 1000.0 / 60.0) * 360.0);
		if (!clockwise) {
			totalAngleRevolutions *= -1.0;
		}
	}

	override function reset() {
		super.reset();
		actor.angle = initialAngle;
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		actor.angle = initialAngle + (curMillis / milliseconds) * totalAngleRevolutions;
	}

	override function toString():String {
		return super.toString() + '($rpm)';
	}
}
