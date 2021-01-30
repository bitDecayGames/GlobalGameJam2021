package input;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;

class BasicControls {
	static var actions:FlxActionManager;

	public var leftHand:FlxActionAnalog;
	public var rightHand:FlxActionAnalog;

	public var pause:FlxActionDigital;

	public function new() {
		leftHand = new FlxActionAnalog("leftHand");
		rightHand = new FlxActionAnalog("rightHand");

		// pause = new FlxActionDigital("pause");

		if (actions == null) {
			actions = FlxG.inputs.add(new FlxActionManager());
		}
		actions.addActions([leftHand, rightHand]);

		updateGamepadInput();
	}

	function updateGamepadInput() {
		leftHand.addGamepad(LEFT_ANALOG_STICK, MOVED);
		rightHand.addGamepad(RIGHT_ANALOG_STICK, MOVED);
		// pause.addGamepad(LEFT_SHOULDER, JUST_PRESSED);
	}
}
