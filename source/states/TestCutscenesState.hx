package states;

import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
import misc.FlxTextFactory;
#if windows
import lime.system.System;
#end

using extensions.FlxStateExt;

import cutscenes.scenes.GroundControlToMajorTomScene;

class TestCutscenesState extends FlxState {
	var _startButton:FlxButton;

	override public function create():Void {
		super.create();
		var scene = new GroundControlToMajorTomScene(this);
		add(scene);

		_startButton = UiHelpers.createMenuButton("Start", () -> {
			scene.start();
		});
		_startButton.setPosition(FlxG.width / 2 - _startButton.width / 2 - 100, FlxG.height - _startButton.height - 40);
		_startButton.updateHitbox();
		add(_startButton);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
