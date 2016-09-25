package sd3.math;

class Rectangle
{
	public var x: Float;
	public var y: Float;
	public var width: Float;
	public var height: Float;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void
	{
		set(x, y, width, height);		
	}

	public function set(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public function setFromObject(object:Object):Void
	{
		var hw = object.model.size.x * 0.5;
		var hh = object.model.size.z * 0.5;

		set(object.position.x - hw, object.position.z - hh, object.model.size.x, object.model.size.z);
	}

	public function checkCollision(r:Rectangle):Bool
	{
		var a: Bool;
		var b: Bool;
		
		if (x < r.x) 
			a = r.x < x + width;
		else 
			a = x < r.x + r.width;
		
		if (y < r.y) 
			b = r.y < y + height;
		else 
			b = y < r.y + r.height;
		
		return a && b;
	}

	public function checkPointInside(px:Float, py:Float):Bool
	{
		if (px > x && px < (x + width) && py > y && py < (py + height))
			return true;
		else
			return false;
	}

	public function getIntersection(r:Rectangle):Rectangle
	{
		var nx:Float = 0; 
		var ny:Float = 0;
		var nw:Float = 0; 
		var nh:Float = 0;

		if (x < r.x)
		{
			nx = r.x;
			nw = Std.int((x + width) - r.x);  
		}
		else
		{
			nx = x;
			
			if ((x + width) < (r.x + r.width))
				nw = width;
			else
				nw = Std.int((r.x + r.width) - x);
		}

		if (y < r.y)
		{
			ny = r.y;
			nh = Std.int((y + height) - r.y);
		}
		else
		{
			ny = y;

			if ((y + height) < (r.y + r.height))
				nh = height;
			else
				nh = Std.int((r.y + r.height) - y);
		}

		return new Rectangle(nx, ny, nw, nh);
	}
	
	public function separate(rect:Rectangle):Void
	{				
		var inter = getIntersection(rect);

		// collided horizontally
		if (inter.height > inter.width)
		{
			// collided from the right
			if ((x + width) > rect.x && (x + width) < (rect.x + rect.width))
				x = rect.x - width;
			// collided from the left
			else
				x = rect.x + rect.width;
		}
		// collided vertically
		else
		{
			// collided from the top
			if ((y + height) > rect.y && (y + height) < (rect.y + rect.height))
				y = rect.y - height;
			// collided from the bottom
			else
				y = rect.y + rect.height;
		}		
	}
}