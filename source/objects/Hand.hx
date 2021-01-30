package objects;

import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Hand extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(15, 15, FlxColor.BLUE);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Polygon(Polygon.box(15, 15));
		trace(poly.localVerts);
		body.shapes.add(poly);


		var shipFilter = new InteractionFilter(CGroups.BODY, ~(CGroups.BODY));
		body.setShapeFilters(shipFilter);

		addPremadeBody(body);
	}
}