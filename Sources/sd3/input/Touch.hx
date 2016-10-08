package sd3.input;

import kha.input.Surface;

class Touch
{	
	public static var touches:Map<Int, TouchData>;

	static var touchCount:Int = 0;
	static var touchJustPressed:Bool = false;

	public function new():Void
	{
		Surface.get().notify(onTouchStart, onTouchEnd, onTouchMove);

		touches = new Map<Int, TouchData>();		
	}

	public function update():Void
	{
		for (key in touches.keys())
		{
			var touch = touches[key];

			// bugfix for safari, otherwise will break everything
			if (touch == null)
				continue;

			if (touch.state == InputState.PRESSED)
			{
				touch.state = InputState.HELD;
			}
			else if (touch.state == InputState.UP)
			{
				touch.state = InputState.NONE;
			}
		}

		touchJustPressed = false;
	}

	public function reset():Void
	{
		for (key in touches.keys())
			touches.remove(key);
	}

	function onTouchStart(index:Int, x:Int, y:Int):Void
	{
		updateTouch(index, x, y);
		touches[index].state = InputState.PRESSED;

		touchCount++;

		touchJustPressed = true;
	}

	function onTouchEnd(index:Int, x:Int, y:Int):Void
	{
		updateTouch(index, x, y);
		touches[index].state = InputState.UP;

		touchCount--;
	}

	function onTouchMove(index:Int, x:Int, y:Int):Void
	{
		updateTouch(index, x, y);		
	}

	inline function updateTouch(index:Int, x:Int, y:Int):Void
	{
		if (touches.exists(index))
		{
			touches[index].rawX = x;
			touches[index].rawY = y;
			touches[index].x = x; //Std.int(x / Sdg.gameScale);
			touches[index].y = y; //Std.int(y / Sdg.gameScale);
			touches[index].dx = x - touches[index].x; //Std.int((x - touches[index].x) / Sdg.gameScale);
			touches[index].dy = y - touches[index].y; //Std.int((y - touches[index].y) / Sdg.gameScale);
		}
		else
		{
			touches.set(index, {
				rawX: x,
				rawY: y,
				x: x, //Std.int(x / Sdg.gameScale),
				y: y, //Std.int(y / Sdg.gameScale),
				dx: 0,
				dy: 0,
				state: InputState.NONE
			});
		}
	}

	inline public static function isPressed(index:Int = 0):Bool
	{
		return touches.exists(index) ? touches[index].state == InputState.PRESSED : false;
	}

	inline public static function isHeld(index:Int = 0):Bool
	{
		return touches.exists(index) ? touches[index].state == InputState.HELD : false;
	}

	inline public static function isUp(index:Int = 0):Bool
	{
		return touches.exists(index) ? touches[index].state == InputState.UP : false;
	}

	inline public static function isAnyHeld():Bool
	{
		return touchCount > 0;
	}

	inline public static function isAnyPressed():Bool
	{
		return touchJustPressed;
	}
}