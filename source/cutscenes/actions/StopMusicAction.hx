package cutscenes.actions;

import cutscenes.Action;

class StopMusicAction extends Action {
	override public function start() {
		super.start();
		FmodManager.StopSong();
		stop();
	}
}
