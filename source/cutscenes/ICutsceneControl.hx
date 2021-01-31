package cutscenes;

interface ICutsceneControl {
	@:isVar public var isStarted(get, null):Bool;
	@:isVar public var isDone(get, null):Bool;
	@:isVar public var isPaused(get, null):Bool;

	public function start():Void;
	public function stop():Void;
	public function pause():Void;
	public function unpause():Void;
	public function reset():Void;
}
