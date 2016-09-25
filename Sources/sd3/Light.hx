package sd3;

import kha.FastFloat;
import kha.Color;
import kha.math.FastVector3;
import kha.math.FastVector4;

class Light
{
	public var position:FastVector4;
	public var color:Color;
	public var ambient:FastFloat;
	public var attenuation:FastFloat;
	public var coneAngle:FastFloat;
	public var coneDirection:FastVector3;
	public var isDirectional(get, set):Bool;	

	public function new(position:FastVector4, ?color:Color):Void
	{
		this.position = position;		
		this.color = color != null ? color : Color.White;
		attenuation = 0.2;
		ambient = 0.5;
		coneAngle = Math.PI;
		coneDirection = new FastVector3();
	}

	public static function fromXYZ(x:FastFloat, y:FastFloat, z:FastFloat, ?color:Color, isDirectional:Bool = false):Light
	{
		return new Light(new FastVector4(x, y, z, isDirectional ? 0 : 1), color);
	}

	inline function get_isDirectional():Bool
	{
		return position.w == 0 ? true : false;
	}

	inline function set_isDirectional(value:Bool):Bool
	{
		position.w = value ? 0 : 1;

		return value; 
	}
}