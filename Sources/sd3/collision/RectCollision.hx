package sd3.collision;

import kha.FastFloat;
import kha.math.FastVector3;
import sd3.math.Rectangle;
import sd3.math.Vec3;

class RectCollision
{
	static var instance:RectCollision;

	var rect1:Rectangle;
	var rect2:Rectangle;

	public var lists:Map<String, Array<Object>>;	

	public function new():Void
	{
		lists = new Map<String, Array<Object>>();

		rect1 = new Rectangle();
		rect2 = new Rectangle();
	}

	public function add(nameList:String, object:Object):Void
	{
		var list = lists.get(nameList);

		if (list == null)
		{
			list = new Array<Object>();
			lists.set(nameList, list);
		}
			
		list.push(object);
	}

	public function remove(nameList:String, object:Object):Void
	{
		var list = lists.get(nameList);

		if (list != null)
			list.remove(object);		
	}

	public function separateObject(nameList:String, object:Object):Void
	{
		var list = lists.get(nameList);

		if (list != null)
		{
			var hw = object.model.size.x * 0.5;
			var hh = object.model.size.z * 0.5;

			rect1.setFromObject(object);

			for (obj in list)
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
	}

	public function checkFirstCollisionObjectList(object:Object, otherObjects:Array<Object>):Object
	{
		var hw = object.model.size.x * 0.5;
		var hh = object.model.size.z * 0.5;

		rect1.setFromObject(object);

		for (obj in otherObjects)
		{
			if (obj != object)
			{
				rect2.setFromObject(obj);

				if (rect1.checkCollision(rect2))			
					return obj;
			}						
		}

		return null;
	}

	public function checkFirstCollisionAreaList(object:Object, positionObjects:Array<FastVector3>, widthObjects:FastFloat, depthObjects:FastFloat):Bool
	{
		var hw = object.model.size.x * 0.5;
		var hh = object.model.size.z * 0.5;

		rect1.setFromObject(object);

		for (position in positionObjects)
		{
			if (position != object.position.value)
			{
				var hwObj = widthObjects * 0.5;
				var hhObj = depthObjects * 0.5;

				rect2.set(position.x - hwObj, position.z - hhObj, widthObjects, depthObjects);

				if (rect1.checkCollision(rect2))			
					return true;
			}						
		}

		return false;
	}

	public function separateArea(nameList:String, position:Vec3, width:FastFloat, depth:FastFloat):Void
	{
		var list = lists.get(nameList);

		if (list != null)
		{
			var hw = width * 0.5;
			var hh = depth * 0.5;

			rect1.set(position.x - hw, position.z - hh, width, depth);

			for (obj in list)
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
	}	

	public static function get():RectCollision
	{
		return instance;
	}

	public static function create():RectCollision
	{
		if (instance == null)
			instance = new RectCollision();

		// TODO: clear lists and objects if instance is not null

		return instance;
	}

	public static function destroy():Void
	{
		instance = null;
	}
}