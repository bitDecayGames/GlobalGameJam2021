package states;

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
		FlxNapeSpace.init();
		FlxNapeSpace.createWalls(0, 0, 0, 0);
		FlxNapeSpace.space.gravity.setxy(0, 500);

		createTestObjs();
	}

	function createTestObjs() {
		var box = new Obstacle(280, FlxG.height - 50);
		add(box);

		var spaceman = new Spaceman(300, 300);
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
