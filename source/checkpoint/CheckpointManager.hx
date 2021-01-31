package checkpoint;

class CheckpointManager {
    private static var x:Float = 0;
    private static var y:Float = 0;
    private static var checkpointNum = 0;

    public static function getX(): Float {
        return x;
    }

    public static function getY(): Float {
        return y;
    }

    public static function setCheckpoint(newX: Float, newY: Float) {
        x = newX;
        y = newY;
        checkpointNum++;
    }
}