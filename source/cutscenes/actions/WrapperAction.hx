package cutscenes.actions;

import cutscenes.Action;

class WrapperAction extends Action {
	private var _action:Action;
	private var _builder:(WrapperAction) -> Action;

	public function new(builder:(WrapperAction) -> Action) {
		super();
		this._builder = builder;
	}

	override function start() {
		checkAction();
		super.start();
	}

	override function reset() {
		super.reset();
		remove(_action);
		_action = null; // the whole point is for the action to be built fresh each time
	}

	override function get_isDone():Bool {
		if (_action != null) {
			return _action.isDone;
		} else {
			return false;
		}
	}

	override function get_isPaused():Bool {
		if (_action != null) {
			return _action.isPaused;
		} else {
			return false;
		}
	}

	override function get_isStarted():Bool {
		if (_action != null) {
			return _action.isStarted;
		} else {
			return false;
		}
	}

	override function get_onDone():() -> Void {
		if (_action != null) {
			return _action.onDone;
		} else {
			return null;
		}
	}

	override function get_onStart():() -> Void {
		if (_action != null) {
			return _action.onStart;
		} else {
			return null;
		}
	}

	override function set_onDone(onDone:() -> Void):() -> Void {
		checkAction();
		return _action.set_onDone(onDone);
	}

	override function set_onStart(onStart:() -> Void):() -> Void {
		checkAction();
		return _action.set_onStart(onStart);
	}

	private function checkAction() {
		if (_action == null) {
			_action = _builder(this);
			add(_action);
		}
	}
}
