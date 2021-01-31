package objects;

import flixel.util.FlxColor;
import constants.CbTypes;
import constants.CGroups;
import constants.Tiles;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Button extends SelfAssigningFlxNapeSprite implements ITargeter {
	public var target: ITriggerable;

	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(Tiles.Size, Tiles.Size, FlxColor.GREEN);

		var body = new Body(BodyType.STATIC);
		var poly = new Polygon(Polygon.box(width, height));
		body.shapes.add(poly);

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
		poly.cbTypes.add(CbTypes.CB_GRABBABLE);
	}

	public function trigger() {
		this.target.trigger();
	}
}
