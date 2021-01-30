package states;

import flixel.FlxSprite;
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

	var spaceman:Spaceman;

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

		var bg = new FlxSprite(AssetPaths.nebula0__png);
		bg.scale.set(3, 3);
		add(bg);

		createTestObjs();
	}

	function createTestObjs() {
		var level = new Level(AssetPaths.jake_test_0__json);
		add(level.wallLayer);

		var box = new Obstacle(280, 300);
		add(box);

		spaceman = new Spaceman(300, 200);
		add(spaceman);

		#if spin
		camera.follow(spaceman.head);
		#end
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		#if spin
		camera.angle = -spaceman.head.angle;
		#end
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
