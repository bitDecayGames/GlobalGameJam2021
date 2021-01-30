package cutscenes.actions;

import cutscenes.Action;

class StartMusicAction extends Action {
	public var song:String;

	/**
	 * On start, starts to play a song, then marks itself as done.  It does NOT wait for the song to finish.
	 * @param song FmodSongs.SomeSongNameHere
	 */
	public function new(song:String) {
		super();
		this.song = song;
		if (song == null)
			throw "Cannot have a null song in the StartMusicAction";
	}

	override public function start() {
		super.start();
		FmodManager.PlaySong(song);
		stop();
	}

	override function toString():String {
		return super.toString() + '($song)';
	}
}
