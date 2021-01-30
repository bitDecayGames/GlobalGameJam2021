package objects;

import nape.shape.Circle;
import constants.CbTypes;
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


		var poly = new Circle(8);

		poly.cbTypes.add(CbTypes.CB_HAND);
		body.shapes.add(poly);

		body.setShapeFilters(new InteractionFilter(CGroups.BODY, ~(CGroups.BODY)));

		addPremadeBody(body);
	}
}