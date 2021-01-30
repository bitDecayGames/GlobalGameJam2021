package source.cutscenes.actions;

import source.cutscenes.Action;
import haxe.Timer;

class ParallelAction extends Action {
	public var waitForAllActionsToFinish:Bool = false;

	private var allDone = false;

	public public function new(waitForAllActionsToFinish:Bool) {
		this.waitForAllActionsToFinish = waitForAllActionsToFinish;
	}

	override public function start() {
		super.start();
		for (member in members) {
			member.start();
		}
	}

	override public function stop() {
		super.stop();
		for (member in members) {
			member.stop();
		}
	}

	override public function pause() {
		super.pause();
		for (member in members) {
			member.pause();
		}
	}

	override public function reset() {
		super.reset();
		for (member in members) {
			member.reset();
		}
	}

	override public function step(elapsed:Float) {
		if (waitForAllActionsToFinish) {
			allDone = true;
			for (member in members) {
				if (!member.isDone) {
					allDone = false;
					break;
				}
			}
			if (allDone) {
				stop();
			}
		} else {
			for (member in members) {
				if (member.isDone) {
					stop();
					break;
				}
			}
		}
	}
}
