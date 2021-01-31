package cutscenes.actions;

class IntervalAction extends WaitAction {
	public var intervalMs:Int;
	public var trigger:() -> Void;

	private var curIntervalMs:Float;

	public function new(intervalMs:Int, milliseconds:Int, trigger:() -> Void) {
		super(milliseconds);
		this.intervalMs = intervalMs;
		this.trigger = trigger;
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		curIntervalMs += (elapsed * 1000);
		if (curIntervalMs > intervalMs) {
			trigger();
			curIntervalMs = 0;
		}
	}
}
