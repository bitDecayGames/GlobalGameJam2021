package states;

import misc.FlxTextFactory;
import misc.Macros;
import signals.Lifecycle;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

/**
 * @author Tanner Moore
 * For games that are deployed to html5, the FMOD audio engine must be loaded before starting the game.
 */
class LoadFmodState extends FlxState {
	private var frameCount:Int = 0;
	private var inited:Bool = false;

	override public function create():Void {
		FmodManager.Initialize();

		var loadingText = FlxTextFactory.make("Loading...", FlxG.width / 2, FlxG.height / 2, 60, FlxTextAlign.CENTER);
		loadingText.x = (FlxG.width / 2) - loadingText.width / 2;
		loadingText.y = (FlxG.height / 2) - loadingText.height / 2;
		add(loadingText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (!inited && frameCount++ > 2) {
			// XXX: FlxG doesn't update all key presses until the second time through update
			inited = true;
			Lifecycle.startup.dispatch();
		}

		if (FmodManager.IsInitialized() && inited) {
			// Once FMOD is ready, and we've dispatched our startup

			#if logan
			FlxG.switchState(new PlayState(AssetPaths.test_level__json));
			#elseif mike
			FlxG.switchState(new MainMenuState());
			#elseif tanner
			#elseif jake
			FlxG.switchState(new PlayState(AssetPaths.main_level__json));
			#elseif jake2
			FlxG.switchState(new PlayState(AssetPaths.jake_level__json));
			#else
			if (Macros.isDefined("SKIP_SPLASH")) {
				FlxG.switchState(new MainMenuState());
			} else {
				FlxG.switchState(new SplashScreenState());
			}
			#end
		}
	}
}
