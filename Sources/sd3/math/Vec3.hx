package sd3.math;

import kha.math.FastVector3;
import kha.FastFloat;

class Vec3
{
	public var value(default, set):FastVector3;	

	public var x(get, set):FastFloat;
	public var y(get, set):FastFloat;
	public var z(get, set):FastFloat;
	public var length(get, set): FastFloat;

	var transform:Transform;

	public function new(transform:Transform, x:FastFloat = 0, y:FastFloat = 0, z:FastFloat = 0):Void
	{	
		this.transform = transform;	
		value = new FastVector3(x, y, z);
	}

	public function set(x:FastFloat, y:FastFloat, z:FastFloat):Void
	{
		value.x = x;
		value.y = y;
		value.z = z;
		transform.matrixDirty = true;
	}

	public function addBy(value:FastVector3):Void
	{
		this.value.x += value.x;
		this.value.y += value.y;
		this.value.z += value.z;
		transform.matrixDirty = true;
	}

	public function multBy(value:FastVector3):Void
	{
		this.value.x *= value.x;
		this.value.y *= value.y;
		this.value.z *= value.z;
		transform.matrixDirty = true;
	}
	
	public inline function multByScalar(value:FastFloat):Void
	{
		this.value.x *= value;
		this.value.y *= value;
		this.value.z *= value;
		transform.matrixDirty = true;
	}
	
	public inline function normalize():Void 
	{
		length = 1;
	}

	function set_value(value:FastVector3):FastVector3
	{
		transform.matrixDirty = true;
		return this.value = value;
	}

	inline function get_x():FastFloat
	{
		return value.x;
	}

	function set_x(value:FastFloat):FastFloat
	{
		transform.matrixDirty = true;
		return this.value.x = value;
	}

	inline function get_y():FastFloat
	{
		return value.y;
	}

	function set_y(value:FastFloat):FastFloat
	{
		transform.matrixDirty = true;
		return this.value.y = value;
	}

	inline function get_z():FastFloat
	{
		return value.z;
	}

	function set_z(value:FastFloat):FastFloat
	{
		transform.matrixDirty = true;
		return this.value.z = value;
	}

	private function get_length():FastFloat
	{
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	private function set_length(length:FastFloat):FastFloat 
	{
		transform.matrixDirty = true;

		var currentLength = get_length();
		if (currentLength == 0) return 0;
		var mul = length / currentLength;
		x *= mul;
		y *= mul;
		z *= mul;

		return length;
	}
}