package cutscenes.actions;

import flixel.math.FlxPoint;
import flixel.FlxSprite;

class ZoomCameraAction extends WaitAction {
	public var zoom:Float;

	private var initialZoom:Float;

	public function new(zoom:Float, milliseconds:Int) {
		super(milliseconds);
		this.zoom = zoom;
	}

	override public function start() {
		super.start();
		initialZoom = camera.zoom;
	}

	override function step(elapsed:Float) {
		super.step(elapsed);
		camera.zoom = initialZoom + (curMillis / milliseconds) * (zoom - initialZoom);
	}
}
