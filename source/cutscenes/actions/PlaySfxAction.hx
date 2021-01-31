package cutscenes.actions;

import cutscenes.Action;

class PlaySfxAction extends Action {
	public var sfx:String;

	public function new(sfx:String) {
		super();
		this.sfx = sfx;
		if (sfx == null)
			throw "Cannot have a null sfx in the PlaySfxAction";
	}

	override public function start() {
		super.start();
		#if !mute
		FmodManager.PlaySoundOneShot(sfx);
		#end
		stop();
	}

	override function toString():String {
		return super.toString() + '($sfx)';
	}
}
