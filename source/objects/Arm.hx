package objects;

import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Arm extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(30, 10, FlxColor.RED);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Polygon([Vec2.get(-15, 5), Vec2.get(-15, -5), Vec2.get(15, -5), Vec2.get(15, 5)]);
		trace(poly.localVerts);
		body.shapes.add(poly);


		var shipFilter = new InteractionFilter(CGroups.BODY, ~(CGroups.BODY));
		body.setShapeFilters(shipFilter);

		addPremadeBody(body);
	}
}