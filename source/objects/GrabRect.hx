package objects;

import nape.geom.Vec2;
import nape.shape.Circle;
import constants.CbTypes;
import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class GrabRect extends SelfAssigningFlxNapeSprite {
	public function new(x:Float, y:Float, asset:String, widthMod:Int = 0, heightMod:Int = 0) {
		super();
		setPosition(x, y);
		loadGraphic(asset);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var useWidth = width + widthMod;
		var useHeight = height + heightMod;

		var poly = new Polygon([
			Vec2.get(-useWidth/2, -useHeight/2),
			Vec2.get(useWidth/2, -useHeight/2),
			Vec2.get(useWidth/2, useHeight/2),
			Vec2.get(-useWidth/2, useHeight/2)]);
		body.shapes.add(poly);

		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
        poly.cbTypes.add(CbTypes.CB_BUMPER);

		body.shapes.add(poly);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE & CGroups.TERRAIN)));
		addPremadeBody(body);
	}
}
