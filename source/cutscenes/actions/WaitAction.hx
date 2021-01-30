package cutscenes.actions;

import cutscenes.Action;
import haxe.Timer;

class WaitAction extends Action {
	public var milliseconds:Int;

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
			Timer.delay(() -> {
				stop();
			}, milliseconds);
		}
	}

	override function toString():String {
		return super.toString() + '($milliseconds ms)';
	}
}
