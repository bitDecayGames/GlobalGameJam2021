package source.cutscenes.actions;

import source.cutscenes.Action;

class StartMusicAction extends Action {
	public var song:FmodSongs;

	public function new(song:FmodSongs) {
		this.song = song;
		if (song == null)
			throw new Exception("Cannot have a null song in the StartMusicAction");
	}

	override public function start() {
		super.start();
		FmodManager.PlaySong(song);
	}
}
