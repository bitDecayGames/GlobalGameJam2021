package objects;

import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Obstacle extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(50, 50, FlxColor.CYAN);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Polygon(Polygon.box(50, 50));
		trace(poly.localVerts);
		body.shapes.add(poly);

		var shipFilter = new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE));
		body.setShapeFilters(shipFilter);

		addPremadeBody(body);
	}
}
