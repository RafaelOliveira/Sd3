package sd3.collision;

import kha.FastFloat;
import kha.math.FastVector2;
import sd3.math.Rectangle;
import sd3.math.Vec3;

class RectCollision
{
	static var instance:RectCollision;

	var rect1:Rectangle;
	var rect2:Rectangle;

	public var scene:Scene;	

	public function new(scene:Scene):Void
	{
		this.scene = scene;

		rect1 = new Rectangle();
		rect2 = new Rectangle();
	}

	public function separateObject(object:Object):Void
	{
		var hw = object.model.size.x * 0.5;
		var hh = object.model.size.z * 0.5;

		rect1.setFromObject(object);

		for (obj in scene.objects)
		{
			rect2.setFromObject(obj);
			if (rect1.checkCollision(rect2))
			{
				rect1.separate(rect2);
				object.position.x = rect1.x + hw;
				object.position.z = rect1.y + hh;
			}
		}
	}	

	public function separateArea(position:Vec3, width:FastFloat, depth:FastFloat):Void
	{
		var hw = width * 0.5;
		var hh = depth * 0.5;

		rect1.set(position.x - hw, position.z - hh, width, depth);

		for (obj in scene.objects)
		{
			rect2.setFromObject(obj);
			if (rect1.checkCollision(rect2))
			{
				rect1.separate(rect2);
				position.x = rect1.x + hw;
				position.z = rect1.y + hh;
			}
		}	
	}	

	public static function get():RectCollision
	{
		return instance;
	}

	public static function set(scene:Scene):RectCollision
	{
		if (instance == null)
			instance = new RectCollision(scene);
		else
			instance.scene = scene;

		return instance;
	}

	public static function destroy():Void
	{
		instance = null;
	}
}