package cutscenes;

import flixel.group.FlxGroup;

using Type;

/**
 * A single unit of movement in a cutscene.  Any child actions will be started and stopped but not waited for.  Use ParallelAction to wait for child actions to finish.
 */
class Action extends FlxTypedGroup<Action> implements ICutsceneControl {
	public var isStarted:Bool = false;
	public var isDone:Bool = false;
	public var isPaused:Bool = false;

	public var onStart:() -> Void;
	public var onDone:() -> Void;

	public function start() {
		if (!isStarted) {
			trace("Start " + this);
			isStarted = true;
			isPaused = false;
			if (onStart != null) {
				onStart();
			}
			for (member in members) {
				member.start();
			}
		}
	}

	public function stop() {
		if (!isDone) {
			isDone = true;
			isPaused = false;
			for (member in members) {
				member.stop();
			}
			trace("Stop " + this);
			if (onDone != null) {
				onDone();
			}
		}
	}

	public function pause() {
		if (isStarted && !isDone) {
			isPaused = true;
		}
		for (member in members) {
			member.pause();
		}
	}

	public function unpause() {
		if (isStarted && !isDone) {
			isPaused = false;
		}
		for (member in members) {
			member.unpause();
		}
	}

	public function reset() {
		if (isStarted && !isDone) {
			stop();
		}
		isStarted = false;
		isDone = false;
		isPaused = false;
		for (member in members) {
			member.reset();
		}
	}

	public function step(elapsed:Float):Void {
		// TODO: implement this method on children of this Action
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (!isPaused && !isDone && isStarted) {
			step(elapsed);
		}
	}

	override function toString():String {
		return this.getClass().getClassName();
	}
}
