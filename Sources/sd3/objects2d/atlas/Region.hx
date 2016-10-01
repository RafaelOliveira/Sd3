package sd3.objects2d.atlas;

/**
 *	Represents a region inside a image
 */
class Region
{
	/** The x position inside the image */
	public var sx:Float;
	
	/** The y position inside the image */
	public var sy:Float;
	
	/** Width of the region */
	public var w:Int;
	
	/** Height of the region */
	public var h:Int;
	
	/** Half of the width */
	public var hw:Int;
	
	/** Half of the height */
	public var hh:Int;
	
	public function new(sx:Float, sy:Float, w:Int, h:Int)
	{
		this.sx = sx;
		this.sy = sy;
		this.w = w;
		this.h = h;
		
		hw = Std.int(w / 2);
		hh = Std.int(h / 2);
	}
}