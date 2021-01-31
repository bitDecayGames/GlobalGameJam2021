package objects;

import nape.shape.Circle;
import constants.CbTypes;
import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class GrabCircle extends SelfAssigningFlxNapeSprite {
	public function new(x:Float, y:Float, asset:String) {
		super();
		setPosition(x, y);
		loadGraphic(asset);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Circle(width / 2);

		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
        poly.cbTypes.add(CbTypes.CB_BUMPER);

		body.shapes.add(poly);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
		addPremadeBody(body);
	}
}
