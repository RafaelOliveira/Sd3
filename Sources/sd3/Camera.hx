package sd3;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.math.FastVector3;

class Camera extends Transform
{	
	static var instance:Camera;	

	public var horizontalAngle(get, set):FastFloat;
	public var verticalAngle(get, set):FastFloat;	
	
	public function new():Void 
	{
		super();
		
		position.set(0, 0, 1);		

		// Projection matrix: 45° Field of View, 4:3 ratio, display range : 0.1 unit <-> 100 units
		matrix = FastMatrix4.perspectiveProjection(45.0, Engine.gameWidth / Engine.gameHeight, 0.1, 100.0);
		matrix = matrix.multmat(FastMatrix4.lookAt(position.value, new FastVector3(0, 0, 0), new FastVector3(0, 1, 0)));		
		matrixDirty = false;		
		
		instance = this;
	}

	override public function update():Void
	{	
		if (matrixDirty)
		{	
			updateDirections();		
			var look = position.value.add(forwardDirection);
			matrix = FastMatrix4.perspectiveProjection(45.0, Engine.gameWidth / Engine.gameHeight, 0.1, 100.0);
			matrix = matrix.multmat(FastMatrix4.lookAt(position.value, look, upDirection));			
			matrixDirty = false;
		}
	}	

	public function updateAngleByMouse(value:FastFloat, mouseDeltaX:FastFloat, mouseDeltaY:FastFloat):Void
	{
		horizontalAngle += 0.005 * mouseDeltaX * -1;
		verticalAngle += 0.005 * mouseDeltaY * -1;		
	}

	public inline function get_horizontalAngle():FastFloat
	{
		return rotation.y;
	}

	public inline function set_horizontalAngle(value:FastFloat):FastFloat
	{
		return rotation.y = value;
	}

	public inline function get_verticalAngle():FastFloat
	{
		return rotation.x;
	}

	public inline function set_verticalAngle(value:FastFloat):FastFloat
	{
		return rotation.x = value;
	}

	public static function get():Camera
	{
		return instance;
	}	
}