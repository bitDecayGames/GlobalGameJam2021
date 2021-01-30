package source.cutscenes.actions;

import source.cutscenes.Action;
import haxe.Timer;

class WaitAction extends Action {
	public var seconds:Float;

	public function new(seconds:Float) {
		this.seconds = seconds;
	}

	override public function start() {
		super.start();
		Timer.delay(() -> {
			stop();
		}, seconds * 1000);
	}
}
