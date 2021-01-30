package cutscenes.actions;

import flixel.FlxSprite;

class SpinAction extends WaitAction {
	public var actor:FlxSprite;
	public var rpm:Float;
	public var clockwise:Bool;

	private var initialAngle:Float;
	private var curMillis:Int;
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
		curMillis = 0;
		totalAngleRevolutions = (rpm * (milliseconds / 1000.0 / 60.0) * 360.0);
		if (!clockwise) {
			totalAngleRevolutions *= -1.0;
		}
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		curMillis += Std.int(elapsed * 1000.0);
		actor.angle = (curMillis / milliseconds) * totalAngleRevolutions;
	}

	override function toString():String {
		return super.toString() + '($rpm)';
	}
}
