package input;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;

class BasicControls {
	static var actions:FlxActionManager;

	public var leftHand:FlxActionAnalog;
	public var rightHand:FlxActionAnalog;

	public var leftGrab:FlxActionDigital;
	public var rightGrab:FlxActionDigital;

	public var legs:FlxActionDigital;

	public function new() {
		leftHand = new FlxActionAnalog("leftHand");
		rightHand = new FlxActionAnalog("rightHand");

		leftGrab = new FlxActionDigital("leftGrab");
		rightGrab = new FlxActionDigital("rightGrab");

		legs = new FlxActionDigital("legs");

		if (actions == null) {
			actions = FlxG.inputs.add(new FlxActionManager());
		}
		actions.addActions([leftHand, rightHand, leftGrab, rightGrab, legs]);

		updateGamepadInput();
	}

	function updateGamepadInput() {
		leftHand.addGamepad(LEFT_ANALOG_STICK, MOVED);
		rightHand.addGamepad(RIGHT_ANALOG_STICK, MOVED);

		leftGrab.addGamepad(LEFT_SHOULDER, PRESSED);
		rightGrab.addGamepad(RIGHT_SHOULDER, PRESSED);

		legs.addGamepad(A, JUST_PRESSED);
	}
}
