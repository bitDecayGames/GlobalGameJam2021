package constants;

import nape.callbacks.CbType;

// Callback types
class CbTypes {
	public static var CB_NAUT:CbType;
	public static var CB_HAND:CbType;
	public static var CB_GRABBABLE:CbType;

	public static function initTypes() {
		CB_NAUT = new CbType();
		trace("CB_NAUT is " + CB_NAUT);
		CB_HAND = new CbType();
		trace("CB_HAND is " + CB_HAND);
		CB_GRABBABLE = new CbType();
		trace("CB_GRABBABLE is " + CB_GRABBABLE);
	}
}
