package states;

import levels.Level;
import flixel.util.FlxColor;
import nape.callbacks.CbType;
import nape.phys.Material;
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
		camera.bgColor = FlxColor.GRAY;
		CbTypes.initTypes();
		FlxNapeSpace.init();

		// var wallMaterial = new Material()
		var walls = FlxNapeSpace.createWalls(0, 0, 0, 0);
		walls.cbTypes.add(CbTypes.CB_GRABBABLE);
		FlxNapeSpace.space.gravity.setxy(0, 0);

		createTestObjs();
	}

	function createTestObjs() {
		var level = new Level(AssetPaths.jake_test_0__json);
		add(level.testLayer);
		add(level.walls);

		var box = new Obstacle(280, 300);
		add(box);

		var spaceman = new Spaceman(300, 200);
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
