package states;

import levels.Level;
import constants.CbTypes;
import objects.Obstacle;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxState;
import objects.Spaceman;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	override public function create() {
		super.create();
		FlxG.camera.pixelPerfectRender = true;
		CbTypes.initTypes();
		FlxNapeSpace.init();
		FlxNapeSpace.createWalls(0, 0, 0, 0);
		FlxNapeSpace.space.gravity.setxy(0, 0);

		createTestObjs();
	}

	function createTestObjs() {
		var level = new Level(AssetPaths.jake_test_0__json);
		add(level.testLayer);

		var box = new Obstacle(280, FlxG.height - 50);
		add(box);

		var spaceman = new Spaceman(300, 400);
		add(spaceman);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
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
