package objects;

import nape.phys.Body;

interface ITriggerable {
    public function getTriggerBody():Body;
    public function trigger():Void;
    public var triggered: Bool;
}