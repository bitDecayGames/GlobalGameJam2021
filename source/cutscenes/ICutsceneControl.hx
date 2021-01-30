package cutscenes;

interface ICutsceneControl {
	public var isStarted:Bool;
	public var isDone:Bool;
	public var isPaused:Bool;

	public function start():Void;
	public function stop():Void;
	public function pause():Void;
	public function unpause():Void;
	public function reset():Void;
}
