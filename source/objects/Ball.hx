package objects;

import nape.shape.Circle;
import constants.CbTypes;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Ball extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		loadGraphic(AssetPaths.ball__png);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Circle(7.5);
		body.shapes.add(poly);

		// body.mass = 10000;

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
		poly.cbTypes.add(CbTypes.CB_BALL);
	}
}
