package states;

import cutscenes.actors.TitleText2;
import flixel.FlxSprite;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
#if windows
import lime.system.System;
#end

using extensions.FlxStateExt;

class SimpleMainMenuState extends FlxUIState {
	var _btnPlay:FlxButton;
	var _btnCredits:FlxButton;
	var _btnExit:FlxButton;

	var _txtTitle:FlxSprite;

	override public function create():Void {
		super.create();
		FmodManager.PlaySong(FmodSongs.Title);
		FlxG.log.notice("loaded scene");
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		var bg = new FlxSprite(AssetPaths.nebulaBackground__png);
		bg.scale.set(2, 2);
		bg.scrollFactor.set(0, 0);
		add(bg);

		_txtTitle = new TitleText2(FlxG.width / 2, FlxG.height / 4);
		add(_txtTitle);

		_btnPlay = UiHelpers.createMenuButton("Play", clickPlay);
		_btnPlay.setPosition(FlxG.width / 2 - _btnPlay.width / 2, FlxG.height - _btnPlay.height - 100);
		_btnPlay.updateHitbox();
		add(_btnPlay);

		_btnCredits = UiHelpers.createMenuButton("Credits", clickCredits);
		_btnCredits.setPosition(FlxG.width / 2 - _btnCredits.width / 2, FlxG.height - _btnCredits.height - 70);
		_btnCredits.updateHitbox();
		add(_btnCredits);

		#if windows
		_btnExit = UiHelpers.createMenuButton("Exit", clickExit);
		_btnExit.setPosition(FlxG.width / 2 - _btnExit.width / 2, FlxG.height - _btnExit.height - 40);
		_btnExit.updateHitbox();
		add(_btnExit);
		#end
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();

		_txtTitle.x = FlxG.width / 2 - _txtTitle.width / 2;
	}

	function clickPlay():Void {
		FmodFlxUtilities.TransitionToStateAndStopMusic(new PlayState(AssetPaths.main_level__json));
	}

	function clickCredits():Void {
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	#if windows
	function clickExit():Void {
		System.exit(0);
	}
	#end

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
