package sd3.objects2d;

import kha.Image;
import kha.math.Vector2;
import kha.math.Vector2i;
import kha.graphics2.Graphics;
import sd3.math.Vector2b;
import sd3.objects2d.atlas.Region;

class Sprite extends Object2d
{
	/**
	 * The image used to render the sprite
	 */
	public var image:Image;
	/**
	 * The region inside the image that is rendered
	 */
	public var region(default, set):Region;

	public var width:Int;
		
	public var height:Int;
	/**
	 * A scale in x to render the region
	 */
	public var scaleX(default, set):Float;	
	/**
	 * A scale in y to render the region
	 */
	public var scaleY(default, set):Float;
	/**
	 * The width of the region with the scale applied
	 */
	var widthScaled(default, null):Int;
	/**
	 * The height of the region with the scale applied
	 */		
	var heightScaled(default, null):Int;
	/**
	 * If the sprite should be rendered flipped
	 */
	public var flip:Vector2b;	
	
	public function new(x:Float, y:Float, image:Image, ?region:Region):Void
	{
		super(x, y);
		
		this.image = image;
		
		if (region != null)
			this.region = region;
		else
			this.region = new Region(0, 0, image.width, image.height);
		
		scaleX = 1;
		scaleY = 1;

		width = this.region.w;
		height = this.region.h;
		
		flip = new Vector2b();				
	}	
	
	override function innerRender(g:Graphics):Void 
	{		
		g.drawScaledSubImage(image, region.sx, region.sy, region.w, region.h,
							 x + (flip.x ? widthScaled : 0),
							 y + (flip.y ? heightScaled : 0), 
							 flip.x ? -widthScaled : widthScaled, flip.y ? -heightScaled : heightScaled);		
	}    
	
	public function setScale(value:Float):Void
	{
		scaleX = value;
		scaleY = value;
	}
	
	public function setFlip(flipX:Bool, flipY:Bool):Void
	{
		flip.x = flipX;
		flip.y = flipY;
	}	
	
	public function set_region(value:Region):Region
	{
		if (value != null)
        {
			width = value.w;
			height = value.h;

            widthScaled = Std.int(value.w * scaleX);
		    heightScaled = Std.int(value.h * scaleY);    
        }
        		
		return region = value;
	}
		
	public function set_scaleX(value:Float):Float
	{		
		widthScaled = Std.int(region.w * value);
		
		return scaleX = value;
	}	
	
	public function set_scaleY(value:Float):Float
	{
		heightScaled = Std.int(region.h * value);
		
		return scaleY = value;
	}
}