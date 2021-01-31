package metrics;

import flixel.FlxG;
import com.bitdecay.analytics.Bitlytics;

class Trackers {
	public static var MAX_SPEED = 0;
	private static var SPEED_BUCKET_SIZE = 20;

	public static function checkSpeed(speed:Float) {
		// save a bunch of reports and just check reasonable increments
		var bracket = Math.floor(speed / SPEED_BUCKET_SIZE) * SPEED_BUCKET_SIZE;
		if (bracket > MAX_SPEED) {
			MAX_SPEED = bracket;
			Bitlytics.Instance().Queue(Metrics.MAX_SPEED, MAX_SPEED);
		}
	}

	public static function sendCheckpoint(checkpoint: Int) {
		Bitlytics.Instance().Queue(Metrics.CHECKPOINTS, checkpoint);
	}
}