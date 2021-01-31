package states;

import flixel.FlxSprite;
import levels.Level;
import flixel.util.FlxColor;
import nape.callbacks.CbType;
import nape.phys.Material;
import constants.CbTypes;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxState;
import objects.Spaceman;

using extensions.FlxStateExt;

class PlayState extends FlxState {

	var levelAssetPath:String;

	var spaceman:Spaceman;

	public function new(levelAssetPath: String) {
		super();
		this.levelAssetPath = levelAssetPath;
	}

	override public function create() {
		super.create();

		FlxG.camera.pixelPerfectRender = true;
		camera.bgColor = FlxColor.GRAY;
		CbTypes.initTypes();
		FlxNapeSpace.init();

		// var wallMaterial = new Material()
		// var walls = FlxNapeSpace.createWalls(0, 0, 0, 0);
		// walls.cbTypes.add(CbTypes.CB_GRABBABLE);
		FlxNapeSpace.space.gravity.setxy(0, 0);

		var bg = new FlxSprite(AssetPaths.nebula0__png);
		bg.scale.set(3, 3);
		add(bg);

		var level = new Level(levelAssetPath);
		add(level.wallLayer);
		add(level.objects);

		#if spin
		camera.follow(spaceman.head);
		#end

		FlxG.debugger.visible = true;
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
