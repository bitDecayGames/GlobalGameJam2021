package constants;

import nape.callbacks.CbType;

// Callback types
class CbTypes {
	public static var CB_NAUT:CbType;

	public static function initTypes() {
		CB_NAUT = new CbType();
		trace("CB_NAUT is " + CB_NAUT);
	}
}
