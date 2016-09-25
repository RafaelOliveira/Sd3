package sd3.input;

import kha.Key;

class Keyboard
{
	static var keysPressed:Map<String, Bool>;
	static var keysHeld:Map<String, Bool>;
	static var keysUp:Map<String, Bool>;
	static var keysCount:Int = 0;
	static var keysJustPressed:Bool = false;	

	public function new():Void
	{
		kha.input.Keyboard.get().notify(onKeyDown, onKeyUp);

		keysPressed = new Map<String, Bool>();
		keysHeld = new Map<String, Bool>();
		keysUp = new Map<String, Bool>();		
	}

	public function update():Void
	{
		for (key in keysPressed.keys())
			keysPressed.remove(key);

		for (key in keysUp.keys())
			keysUp.remove(key);

		keysJustPressed = false;
	}

	public function reset():Void
	{
		for (key in keysPressed.keys())
			keysPressed.remove(key);

		for (key in keysHeld.keys())
			keysHeld.remove(key);

		for (key in keysUp.keys())
			keysUp.remove(key);
	}

	function onKeyDown(key:Key, char:String):Void
	{
		if (key == Key.CHAR)
		{                                 
			keysPressed.set(char, true);
			keysHeld.set(char, true);
		}
		else
		{                  
			keysPressed.set(key.getName().toLowerCase(), true);
			keysHeld.set(key.getName().toLowerCase(), true);
		}

		keysCount++;

		keysJustPressed = true;
	}

	function onKeyUp(key:Key, char:String):Void
	{		
		if (key == Key.CHAR)
		{
			keysUp.set(char, true);
			keysHeld.set(char, false);
		}
		else
		{
			keysUp.set(key.getName().toLowerCase(), true);
			keysHeld.set(key.getName().toLowerCase(), false);
		}

		keysCount--;
	}

	inline public static function isPressed(key:String):Bool
	{
		return keysPressed.exists(key);
	}

	inline public static function isHeld(key:String):Bool
	{
		return keysHeld.get(key);
	}

	inline public static function isUp(key:String):Bool
	{
		return keysUp.exists(key);
	}

	inline public static function isAnyHeld():Bool
	{
		return (keysCount > 0);
	}

	inline public static function isAnyPressed():Bool
	{
		return keysJustPressed;
	}
}