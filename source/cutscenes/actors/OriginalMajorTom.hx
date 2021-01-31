package cutscenes.actors;

import flixel.FlxSprite;

class OriginalMajorTom extends FlxSprite {
	public function new() {
		super();
		loadGraphic(AssetPaths.OriginalMajorTom__png, true, 20, 20);
		var animationSpeed:Int = 8;
		animation.add("stand", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], animationSpeed, true);
		animation.add("fall", [12, 13], animationSpeed, false);
		animation.add("aim", [24, 25, 26], animationSpeed, false);
		animation.add("slow-aim", [24, 25, 26], animationSpeed * 0.1, false);
		animation.add("throw", [36, 37, 38, 39], animationSpeed, false);
		animation.add("slow-throw-start", [36, 37], animationSpeed * 0.1, false);
		animation.add("slow-throw-finish", [38, 39], animationSpeed * 0.1, false);
		animation.add("teleport-in", [48, 49, 50, 51, 52, 53, 54, 55, 56], animationSpeed, false);
		animation.add("teleport-out", [60, 61, 62, 63, 64, 65], animationSpeed, false);
		animation.add("teleport-in-fall", [48, 61, 49, 60, 12, 13], animationSpeed, false);
	}
}
