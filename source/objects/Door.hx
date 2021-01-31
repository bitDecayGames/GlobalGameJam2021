package objects;

import flixel.util.FlxColor;
import constants.CbTypes;
import constants.CGroups;
import constants.Tiles;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;

class Door extends SelfAssigningFlxNapeSprite implements ITriggerable {
	public var triggered = false;

	public function new(x:Int, y:Int) {
		super();
		setPosition(x, y);
		makeGraphic(Tiles.Size, Tiles.Size * 5, FlxColor.YELLOW);

		var body = new Body(BodyType.STATIC);
		var poly = new Polygon(Polygon.box(width, height));
		body.shapes.add(poly);

		addPremadeBody(body);
		body.setShapeFilters(new InteractionFilter(CGroups.OBSTACLE, ~(CGroups.OBSTACLE)));
	}

	public function trigger() {
		triggered = true;
		this.kill();
	}
}
