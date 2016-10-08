package sd3;

import kha.Color;
import kha.Image;
import sd3.input.Keyboard;

class Util
{
	public static function moveTransformByKeyboard(transform:Transform, value:Float):Void
	{
		if (Keyboard.isHeld('a') || Keyboard.isPressed('left'))			
			transform.moveToLeft(value);
		else if (Keyboard.isHeld('d') || Keyboard.isPressed('right'))			
			transform.moveToRight(value);
		
		if (Keyboard.isHeld('w') || Keyboard.isPressed('up'))
			transform.moveForward(value);
		else if (Keyboard.isHeld('s') || Keyboard.isPressed('down'))
			transform.moveBackward(value);
	}

	public static function createRectImage(width:Int, height:Int, color:Color):Image
	{
		var image = Image.createRenderTarget(width, height);
		image.g2.begin(true, color);
		image.g2.end();

		return image; 
	}
}