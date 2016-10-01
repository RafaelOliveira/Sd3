package sd3.objects2d;

import kha.Image;
import kha.graphics2.Graphics;
import sd3.objects2d.atlas.Region;

class NineSlice extends Object2d
{
	/**
	 * The image used to render the sprite
	 */
	public var image:Image;
	/**
	 * The region inside the image that is rendered
	 */
	public var region:Region;	
	
	var leftBorder:Int;
	var rightBorder:Int;
	var topBorder:Int;
	var bottomBorder:Int;
	
	var width:Int;
	var height:Int;

	public function new (leftBorder:Int, rightBorder:Int, topBorder:Int, bottomBorder:Int, width:Int, height:Int, image:Image, ?region:Region):Void
	{
		super();
		
		this.image = image;
		
		if (region != null)
			this.region = region;
		else
			this.region = new Region(0, 0, image.width, image.height);

		this.leftBorder = leftBorder == 0 ? 0 : leftBorder;
		this.rightBorder = rightBorder == 0 ? 0 : rightBorder;
		this.topBorder = topBorder == 0 ? 0 : topBorder;
		this.bottomBorder = bottomBorder == 0 ? 0 : bottomBorder;
		
		this.width = width - leftBorder - rightBorder;
		this.height = height - topBorder - bottomBorder;
		
		if (this.width < 0)
			this.width = 0;
			
		if (this.height < 0)
			this.height = 0;		
	}	

	override function innerRender(g:Graphics):Void
	{
		if (leftBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx, region.sy + topBorder,	// sxy
				leftBorder, region.h - topBorder - bottomBorder,			// swh
				x, y + topBorder,											// xy
				leftBorder, height);										// wh
		}

		if (rightBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx + region.w - rightBorder, region.sy + region.sy + topBorder,
				rightBorder, region.h - topBorder - bottomBorder,
				x + leftBorder + width, y + topBorder,
				rightBorder, height);
		}

		if (topBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx + leftBorder, region.sy,
				region.w - leftBorder - rightBorder, topBorder,
				x + leftBorder, y,
				width, topBorder);
		}

		if (bottomBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx + leftBorder, region.h - bottomBorder,
				region.w - leftBorder - rightBorder, bottomBorder,
				x + leftBorder, y + topBorder + height,
				width, bottomBorder);
		}

		if (leftBorder > 0 && topBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx, region.sy, 
				leftBorder, topBorder,
				x, y, 
				leftBorder, topBorder);
		}

		if (rightBorder > 0 && topBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx + region.w - rightBorder, region.sy, 
				rightBorder, topBorder,
				x + leftBorder + width,	y,
				rightBorder, topBorder);
		}

		if (leftBorder > 0 && bottomBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx, region.sy + region.h - bottomBorder,
				leftBorder, bottomBorder,
				x, y + topBorder + height,
				leftBorder, bottomBorder);
		}

		if (rightBorder > 0 && bottomBorder > 0)
		{
			g.drawScaledSubImage(image, region.sx + region.w - rightBorder, region.sy + region.h - bottomBorder,
				rightBorder, bottomBorder,
				x + leftBorder + width, y + topBorder + height,
				rightBorder, bottomBorder);
		}

		g.drawScaledSubImage(image, region.sx + leftBorder, region.sy + topBorder,
			region.w - leftBorder - rightBorder, region.h - topBorder - bottomBorder,
			x + leftBorder, y + topBorder,
			width, height);
	}
}