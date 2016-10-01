package sd3.objects2d;

import kha.Image;
import kha.math.Vector2;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import sd3.objects2d.atlas.Region;

class TileSprite extends Object2d
{
    public var image:Image;
    /**
	 * The region inside the image that is rendered
	 */
	public var region(default, set):Region;

    public var width(default, set):Int;
    public var height(default, set):Int;
    
    var restWidth:Int;
    var restHeight:Int;    
    
    var columns:Int;
    var rows:Int;
    
    var cursor:Vector2;
    
    public function new(x:Float, y:Float, width:Int, height:Int, image:Image, ?region:Region):Void
    {
        super(x, y);

        this.image = image;

        if (region != null)
			this.region = region;
		else
			this.region = new Region(0, 0, image.width, image.height);
        
        this.width = width;
        this.height = height;        
        
        cursor = new Vector2();
    }
    
    override function innerRender(g:Graphics):Void 
	{
        var w = 0;
        var h = 0;
        
        cursor.y = y;
        
        for (r in 0...rows)
        {                        
            cursor.x = x;
            
            if (restHeight > 0 && r == (rows - 1))
                h = restHeight;                
            else
                h = region.h;                         
            
            for (c in 0...columns)
            {
                if (restWidth > 0 && c == (columns - 1))
                    w = restWidth;                    
                else
                    w = region.w;
                
                g.drawScaledSubImage(image, region.sx, region.sy, w, h,
                    cursor.x - cx, cursor.y - cy, w, h);
                  
                cursor.x += w;
            }
                        
            cursor.y += h;
        }               
	}    
    
    function set_width(value:Int):Int
    {
        if (value > region.w)
        {                    
            columns = Std.int(value / region.w);
            
            restWidth = Std.int(value % region.w);
            if (restWidth > 0)
                columns++;
        }
        else
        {
            columns = 1;
            restWidth = Std.int(value % region.w);
        }
        
        return width = value;
    }
    
    function set_height(value:Int):Int
    {
        if (value > region.h)
        {                    
            rows = Std.int(value / region.h);
            
            restHeight = Std.int(value % region.h);
            if (restHeight > 0)
                rows++;
        }
        else
        {
            rows = 1;
            restHeight = Std.int(value % region.h);
        }    
        
        return height = value;
    }
}