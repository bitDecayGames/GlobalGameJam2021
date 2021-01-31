package objects;

import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Door extends SelfAssigningFlxNapeSprite implements ITriggerable {
	public var triggered = false;

	public function new(x:Float, y:Float) {
		super();
		setPosition(x, y);
		loadGraphic(AssetPaths.door_C__png);

		var body = new Body(BodyType.KINEMATIC);
		var poly = new Polygon(Polygon.box(width, height));
		body.shapes.add(poly);

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
	}

	public function trigger() {
		triggered = true;
		this.body.space = null;
		loadGraphic(AssetPaths.door_O__png);

		// SFX: Door opening
	}

	public function getTriggerBody():Body {
		return body;
	}
}
