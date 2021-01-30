package cutscenes.actions;

import cutscenes.Action;
import haxe.Timer;

class WaitAction extends Action {
	public var milliseconds:Int;

	public function new(milliseconds:Int) {
		super();
		this.milliseconds = milliseconds;
	}

	override public function start() {
		super.start();
		Timer.delay(() -> {
			stop();
		}, milliseconds);
	}
}
