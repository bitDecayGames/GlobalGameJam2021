package objects;

import nape.shape.Circle;
import constants.CbTypes;
import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Head extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int, asset:String) {
		super();
		setPosition(x, y);
		loadGraphic(asset);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Circle(width / 2);

		poly.cbTypes.add(CbTypes.CB_HAND);
		body.shapes.add(poly);

		body.setShapeFilters(new InteractionFilter(CGroups.BODY, ~(CGroups.BODY)));
		addPremadeBody(body);
	}
}
