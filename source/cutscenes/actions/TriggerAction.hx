package cutscenes.actions;

import cutscenes.Action;

class TriggerAction extends Action {
	public function new(trigger:() -> Void) {
		super();
		this.onStart = () -> {
			if (trigger != null) {
				trigger();
			}
			stop();
		};
	}
}
