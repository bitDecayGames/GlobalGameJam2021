package constants;

// CGroups are collision group flags
class CGroups {
	public static inline var TERRAIN:Int = 0x1 << 0;

	public static inline var BODY:Int = 0x1 << 1;
	public static inline var OBSTACLE:Int = 0x1 << 2;

	public static inline var OTHER_SENSOR:Int = 0x1 << 31;

	// public static inline var TOW_COLLIDERS:Int = CARGO & HATCHES & TERRAIN;
	public static inline var ALL:Int = ~(0);
}
