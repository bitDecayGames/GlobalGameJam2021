package states;

import objects.Ball;
import flixel.FlxG;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxSprite;
import levels.Level;
import flixel.util.FlxColor;
import constants.CbTypes;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxState;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	public static var stopFollow = false;

	var levelAssetPath:String;
	var level:Level;

	public function new(levelAssetPath:String) {
		super();
		this.levelAssetPath = levelAssetPath;
	}

	override public function create() {
		super.create();

		FmodManager.PlaySong(FmodSongs.Weightless);

		camera.bgColor = FlxColor.GRAY;

		#if !nospin
		var ogWidth = FlxG.width;
		var ogHeight = FlxG.height;

		// // make our camera fill the screen even when rotated
		FlxG.camera.width = Std.int(Math.sqrt(Math.pow(FlxG.width, 2) + Math.pow(FlxG.height, 2)));
		FlxG.camera.height = camera.width;
		FlxG.camera.x = (FlxG.camera.width - ogWidth) / -2;
		FlxG.camera.y = (FlxG.camera.height - ogHeight) / -2;
		#end

		CbTypes.initTypes();
		FlxNapeSpace.init();

		// var wallMaterial = new Material()
		// var walls = FlxNapeSpace.createWalls(0, 0, 0, 0);
		// walls.cbTypes.add(CbTypes.CB_GRABBABLE);
		FlxNapeSpace.space.gravity.setxy(0, 0);

		var bg = new FlxSprite(AssetPaths.nebula0__png);
		bg.scale.set(3, 3);
		add(bg);

		level = new Level(levelAssetPath);
		add(level.background1);
		add(level.background2);
		add(level.wallLayer);
		add(level.objects);

		#if logan
		add(new Ball(400, 200));
		#end

		camera.follow(level.player.torso, FlxCameraFollowStyle.PLATFORMER);
		camera.deadzone.y = 0;
		camera.deadzone.height = FlxG.height;

		#if !nospin
		camera.follow(level.player.torso);
		#end

		// FlxG.debugger.visible = true;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		#if !nospin
		if (!stopFollow) {
			camera.angle = -level.player.torso.angle;
		}
		#end

		metrics.Trackers.checkSpeed(level.player.torso.body.velocity.length);
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
