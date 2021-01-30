package objects;

import constants.CbTypes;
import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class WallSegment extends SelfAssigningFlxNapeSprite {
	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(32, 32, FlxColor.YELLOW);

		var body = new Body(BodyType.STATIC);

		var poly = new Polygon(Polygon.box(32, 32));
		body.shapes.add(poly);
		addPremadeBody(body);

		body.setShapeFilters(new InteractionFilter(CGroups.WALL, ~(CGroups.WALL)));
		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
	}
}
