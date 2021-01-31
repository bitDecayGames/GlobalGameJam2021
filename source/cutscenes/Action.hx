package cutscenes;

import flixel.group.FlxGroup;

using Type;

/**
 * A single unit of movement in a cutscene.  Any child actions will be started and stopped but not waited for.  Use ParallelAction to wait for child actions to finish.
 */
class Action extends FlxTypedGroup<Action> implements ICutsceneControl {
	@:isVar public var isStarted(get, null):Bool;
	@:isVar public var isPaused(get, null):Bool;
	@:isVar public var isDone(get, null):Bool;

	@:isVar public var onStart(get, set):() -> Void;
	@:isVar public var onDone(get, set):() -> Void;

	public function get_isStarted():Bool {
		return isStarted;
	}

	public function get_isPaused():Bool {
		return isPaused;
	}

	public function get_isDone():Bool {
		return isDone;
	}

	public function get_onStart():() -> Void {
		return onStart;
	}

	public function set_onStart(onStart):() -> Void {
		return this.onStart = onStart;
	}

	public function get_onDone():() -> Void {
		return onDone;
	}

	public function set_onDone(onDone):() -> Void {
		return this.onDone = onDone;
	}

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
		// implement this method on children of this Action
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (isStarted && !isPaused && !isDone) {
			step(elapsed);
		}
	}

	override function toString():String {
		return this.getClass().getClassName();
	}
}
