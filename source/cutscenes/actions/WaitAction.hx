package cutscenes.actions;

import cutscenes.Action;

class WaitAction extends Action {
	public var milliseconds:Int;

	private var curMillis:Int;

	/**
	 * Waits for a given number of milliseconds then stops
	 * @param milliseconds -1 means the timer will not run and this will never call stop()
	 */
	public function new(milliseconds:Int) {
		super();
		this.milliseconds = milliseconds;
	}

	override public function start() {
		super.start();
		if (milliseconds >= 0) {
			curMillis = 0;
		}
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		if (curMillis <= milliseconds) {
			curMillis += Std.int(elapsed * 1000.0);
			if (curMillis > milliseconds) {
				stop();
			}
		}
	}

	override function toString():String {
		return super.toString() + '($milliseconds ms)';
	}
}
