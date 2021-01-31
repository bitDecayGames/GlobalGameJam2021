package objects;

import constants.CbTypes;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Obstacle extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		loadGraphic(AssetPaths.crate__png);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Polygon(Polygon.box(width, height));
		body.shapes.add(poly);

		body.mass = 10000;

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
	}
}
