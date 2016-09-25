package sd3.input;

import kha.input.Mouse;

class Mouse
{
	public static var x:Int = 0;
	public static var y:Int = 0;

	// deltas of x and y
	public static var dx:Int = 0;
	public static var dy:Int = 0;

	static var mousePressed:Map<Int, Bool>;
	static var mouseHeld:Map<Int, Bool>;
	static var mouseUp:Map<Int, Bool>;
	static var mouseCount:Int = 0;
	static var mouseJustPressed:Bool = false;

	public function new():Void
	{
		kha.input.Mouse.get().notify(onMouseStart, onMouseEnd, onMouseMove, onMouseWheel);

		mousePressed = new Map<Int, Bool>();
		mouseHeld = new Map<Int, Bool>();
		mouseUp = new Map<Int, Bool>();		
	}

	public function update():Void
	{
		for (key in mousePressed.keys())
			mousePressed.remove(key);

		for (key in mouseUp.keys())
			mouseUp.remove(key);

		mouseJustPressed = false;		
	}

	public function postUpdate():Void
	{
		dx = 0;
		dy = 0;
	}

	public function reset():Void
	{
		for (key in mousePressed.keys())
			mousePressed.remove(key);

		for (key in mouseHeld.keys())
			mouseHeld.remove(key);

		for (key in mouseUp.keys())
			mouseUp.remove(key);
	}

	function onMouseStart(index:Int, x:Int, y:Int):Void
	{		
		updateMouseData(x, y, 0, 0);

		mousePressed.set(index, true);
		mouseHeld.set(index, true);

		mouseCount++;
		mouseJustPressed = true;
	}

	function onMouseEnd(index:Int, x:Int, y:Int):Void
	{
		updateMouseData(x, y, 0, 0);

		mouseUp.set(index, true);
		mouseHeld.remove(index);

		mouseCount--;
	}

	function onMouseMove(x:Int, y:Int, dx:Int, dy:Int):Void
	{
		updateMouseData(x, y, dx, dy);		
	}

	function updateMouseData(x:Int, y:Int, dx:Int, dy:Int):Void
	{
		Mouse.x = x;
		Mouse.y = y;		
		Mouse.dx = dx;
		Mouse.dy = dy;		
	}

	function onMouseWheel(delta:Int):Void
	{
		// TODO
		trace("onMouseWheel : " + delta);
	}

	inline public static function isPressed(index:Int = 0):Bool
	{
		return mousePressed.exists(index);
	}

	inline public static function isHeld(index:Int = 0):Bool
	{
		return mouseHeld.exists(index);
	}

	inline public static function isUp(index:Int = 0):Bool
	{
		return mouseUp.exists(index);
	}

	inline public static function isAnyHeld():Bool
	{
		return mouseCount > 0;
	}

	inline public static function isAnyPressed():Bool
	{
		return mouseJustPressed;
	}
}