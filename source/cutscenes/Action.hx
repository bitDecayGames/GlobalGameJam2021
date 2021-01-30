package source.cutscenes;

import flixel.group.FlxGroup;

/**
 * A single unit of movement in a cutscene
 */
class Action extends FlxGroup implements ICutsceneControl {
	public var isStarted:Bool = false;
	public var isDone:Bool = false;
	public var isPaused:Bool = false;

	public var onStart:(Action) -> Void;
	public var onDone:(Action) -> Void;

	public function start() {
		if (!isStarted && onStart != null) {
			isStarted = true;
			isPaused = false;
			onStart(this);
		}
	}

	public function stop() {
		isDone = true;
		isPaused = false;
		if (onDone != null) {
			onDone(this);
		}
	}

	public function pause() {
		if (isStarted && !isDone) {
			isPaused = !isPaused;
		}
	}

	public function reset() {
		if (isStarted && !isDone) {
			stop();
		}
		isStarted = false;
		isDone = false;
		isPaused = false;
	}

	public function step(elapsed:Float):Void {
		// TODO: implement this method on children of this Action
	}

	override public function create():Void {}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (!isPaused && !isDone && isStart) {
			step(elapsed);
		}
	}
}
