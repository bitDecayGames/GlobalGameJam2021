package source.cutscenes;

interface ICutsceneControl {
	public var isStarted:Bool = false;
	public var isDone:Bool = false;
	public var isPaused:Bool = false;

	public function start();
	public function stop();
	public function pause();
	public function reset();
}
