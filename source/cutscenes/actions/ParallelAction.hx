package cutscenes.actions;

import cutscenes.Action;

class ParallelAction extends Action {
	private var allDone:Bool = false;

	override public function step(elapsed:Float):Void {
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
	}
}
