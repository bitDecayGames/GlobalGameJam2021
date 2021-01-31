package states;

import flixel.addons.ui.FlxUIState;
import flixel.util.FlxColor;
#if windows
import lime.system.System;
#end

using extensions.FlxStateExt;

import cutscenes.scenes.GroundControlToMajorTomScene;

class MainMenuState extends FlxUIState {
	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;

		var scene = new GroundControlToMajorTomScene(this);
		add(scene);
		scene.start();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
