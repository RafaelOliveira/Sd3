package sd3.objects2d;

import kha.graphics2.Graphics;
import kha.Color;
import kha.FastFloat;
import kha.math.Vector2;

class Object2d
{	
	/** 
	 * A name for identification and debugging
	 */
	public var name:String;		
	/**
	 * The x position 
	 */
	public var x:Float;
	/** 
	 * the y position 
	 */
	public var y:Float;
	/** 
	 * Tint color 
	 */
	public var color:Color;
	/**
	 * Alpha amount
	 */
	public var alpha:Float;
	/**
	 * The angle of the rotation in radians 
	 */
	public var angle:FastFloat;
	/**
	 * The pivot point of the rotation 
	 */
	public var pivot:Vector2;	
	/**
	 * If the object can update 
	 */ 
	public var active:Bool;		
	/**
	 * If the object should render
	 */
	public var visible:Bool;	
	/**
	 * The screen this object belongs 
	 */
	public var scene:Scene;	
	
	public function new(x:Float = 0, y:Float = 0):Void
	{
		this.name = '';	
		this.x = x;
		this.y = y;        

		color = Color.White;
		alpha = 1;
		angle = 0;
		pivot = new Vector2();
		
		active = true;
		visible = true;		
	}
	
	/**
	 * Override this, called when the Object is added to a Screen.
	 */
	public function added():Void {}

	/**
	 * Override this, called when the Object is removed from a Screen.
	 */
	public function removed():Void {}	
	
	public function update():Void {}
	
	public function setPosition(x:Float, y:Float):Void
	{
		this.x = x;
		this.y = y;
	}

	public function setSizeAuto():Void {}

	public function setPivot(pivotX:Float, pivotY:Float):Void
	{
		pivot.x = pivotX;
		pivot.y = pivotY;
	}

	public function render(g:Graphics):Void 
	{			
		if (angle != 0)
			g.pushRotation(angle, x + pivot.x, y + pivot.y);		
			
		if (alpha != 1) 
			g.pushOpacity(alpha);
		
		g.color = color;
			
		innerRender(g);
		
		if (alpha != 1)
			g.popOpacity();
			
		if (angle != 0)		
			g.popTransformation();
	}
	
	function innerRender(g:Graphics):Void {}	
}