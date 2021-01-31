package cutscenes.actions;

import cutscenes.Action;

class TriggerAction extends Action {
	public var trigger:() -> Void;

	public function new(trigger:() -> Void) {
		super();
		this.trigger = trigger;
	}

	override function start() {
		super.start();
		if (trigger != null) {
			trigger();
		}
		stop();
	}
}
