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
	public static inline var OPEN_ANIM = "open";
	public static inline var CLOSED_ANIM = "closed";

	public function new(x:Float, y:Float, asset:String) {
		super();
		setPosition(x, y);
		loadGraphic(asset, true, 20, 24);

		animation.add(OPEN_ANIM, [0]);
		animation.add(CLOSED_ANIM, [1]);

		animation.play(OPEN_ANIM);

		var body = new Body(BodyType.DYNAMIC);
		body.isBullet = true;

		var poly = new Circle(8);

		poly.cbTypes.add(CbTypes.CB_HAND);
		body.shapes.add(poly);

		body.setShapeFilters(new InteractionFilter(CGroups.BODY, ~(CGroups.BODY)));
		addPremadeBody(body);
	}
}
