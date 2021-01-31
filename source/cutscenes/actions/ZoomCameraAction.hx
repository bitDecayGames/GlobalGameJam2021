package cutscenes.actions;

import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class ZoomCameraAction extends WaitAction {
	public var cam:FlxCamera;
	public var zoom:Float;

	private var initialZoom:Float;

	public function new(camera:FlxCamera, zoom:Float, milliseconds:Int) {
		super(milliseconds);
		this.cam = camera;
		this.zoom = zoom;
	}

	override public function start() {
		super.start();
		initialZoom = cam.zoom;
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		cam.zoom = initialZoom + (curMillis / milliseconds) * (zoom - initialZoom);
	}
}
