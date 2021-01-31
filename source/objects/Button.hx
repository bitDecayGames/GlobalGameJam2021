package objects;

import constants.CbTypes;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Button extends SelfAssigningFlxNapeSprite implements ITargeter {
	public var triggered = false;
	public var targets: Array<ITriggerable> = [];

	public function new(x:Float, y:Float) {
		super();
		setPosition(x, y);
		loadGraphic(AssetPaths.buttonCombo__png);

		var body = new Body(BodyType.STATIC);
		var poly = new Polygon(Polygon.box(width, height));
		body.shapes.add(poly);

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
	}

	public function trigger() {
		if (!this.triggered) {
			triggered = true;
			loadGraphic(AssetPaths.buttonBase__png);
			for (t in this.targets) {
				t.trigger();
			}
		}
	}

	public function getTriggerBody():Body {
		return body;
	}
}
