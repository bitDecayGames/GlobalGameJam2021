package cutscenes.actors;

import flixel.FlxSprite;

class TitleText2 extends FlxSprite {
	public function new() {
		super();
		loadGraphic(AssetPaths.eventful2animation__png, true, 240, 123);
		animation.add("default", [0, 1, 2, 3], 10);
		animation.play("default");
	}
}
