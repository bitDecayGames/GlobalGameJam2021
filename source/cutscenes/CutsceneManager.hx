package source.cutscenes;

import flixel.FlxGroup;

/**
 * A manager class for handling and playing through cutscenes.
 */
class CutsceneManager extends FlxTypedGroup<Action> implements ICutsceneControl {
	private var currentActionIndex:Int = -1;

	public var isStarted:Bool = false;
	public var isDone:Bool = false;
	public var isPaused:Bool = false;

	public function start() {
		if (!isStarted) {
			isStarted = true;
			isPaused = false;
			currentActionIndex = -1;
			startNext();
		}
	}

	public function stop() {
		if (isStarted && !isDone) {
			isDone = true;
			isPaused = false;
			var cur = getCurrent();
			if (cur != null && !cur.isDone) {
				cur.onDone = null;
				cur.stop();
			}
		}
	}

	public function pause() {
		if (isStarted && !isDone) {
			isPaused = !isPaused;
			var cur = getCurrent();
			if (cur != null && cur.isPaused != isPaused) {
				cur.pause();
			}
		}
	}

	public function reset() {
		if (isStarted && !isDone) {
			stop();
		}
		currentActionIndex = -1;
		isStarted = false;
		isDone = false;
		isPaused = false;
		for (member in members) {
			member.onDone = null;
			member.reset();
		}
	}

	override public function create():Void {}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	private function getCurrent():Action {
		if (members != null && members.length > 0 && currentActionIndex < members.length) {
			return members[currentActionIndex];
		}
		return null;
	}

	private function startNext():Void {
		if (members != null && members.length > 0 && currentActionIndex + 1 < members.length) {
			curentActionIndex = currentActionIndex + 1;
			var action = members[currentActionIndex];
			if (action != null) { // MW possibly need to check if the action is "alive"
				action.onDone = () -> {
					action.onDone = null;
					// recursively call startNext until there are no actions left (actions play out synchronously)
					startNext();
				};
				// if this action never calls onDone, then you will be stuck on this action forever
				action.start();
			} else {
				// if the current action is null, then go to the next action
				startNext();
			}
		} else {
			// if you are out of actions, then stop
			stop();
		}
	}
}
