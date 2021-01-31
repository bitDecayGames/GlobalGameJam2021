package cutscenes.actors;

import flixel.FlxSprite;

class OriginalTeleBall extends FlxSprite {
	public function new() {
		super();
		loadGraphic(AssetPaths.OriginalTeleBall__png, true, 20, 20);
		var animationSpeed:Int = 3;
		animation.add("blink", [0, 1], animationSpeed, true);
		animation.add("slow-blink", [0, 1], animationSpeed * 0.5, true);
	}
}
