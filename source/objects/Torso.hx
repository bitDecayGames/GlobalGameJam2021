package objects;

import flixel.util.FlxColor;
import constants.CGroups;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Torso extends SelfAssigningFlxNapeSprite {
	public function new(x:Float, y:Float) {
		super();
		setPosition(x, y);
		loadGraphic(AssetPaths.torso__png);
		// makeGraphic(30, 60, FlxColor.YELLOW);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Polygon([Vec2.get(-width/2, -height/2), Vec2.get(width/2, -height/2), Vec2.get(width/2, height/2), Vec2.get(-width/2, height/2)]);
		body.shapes.add(poly);

		var shipFilter = new InteractionFilter(CGroups.BODY, ~(CGroups.BODY));
		body.setShapeFilters(shipFilter);

		addPremadeBody(body);
	}
}
