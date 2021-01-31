package constants;

import nape.callbacks.CbType;

// Callback types
class CbTypes {
	public static var CB_NAUT:CbType;
	public static var CB_HAND:CbType;
	public static var CB_GRABBABLE:CbType;
	public static var CB_BALL:CbType;

	public static function initTypes() {
		CB_NAUT = new CbType();
		CB_HAND = new CbType();
		CB_GRABBABLE = new CbType();
		CB_BALL = new CbType();
	}
}
