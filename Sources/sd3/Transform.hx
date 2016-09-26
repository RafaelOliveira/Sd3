package sd3;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.math.FastVector3;
import sd3.math.Vec3;

class Transform
{
	public var position:Vec3;
	public var rotation:Vec3;
	public var scale:Vec3;

	public var forwardDirection:FastVector3;
	public var rightDirection:FastVector3;
	public var upDirection:FastVector3;

	public var matrix:FastMatrix4;
	public var matrixDirty:Bool;
	public var normalMatrix:FastMatrix4;	

	public function new():Void
	{
		position = new Vec3(this);
		rotation = new Vec3(this);
		scale = new Vec3(this, 1, 1, 1);

		updateDirections();

		matrix = FastMatrix4.identity();		
		matrixDirty = false;		
	}

	public function update():Void {}	

	public function updateMatrix(position:FastVector3, rotation:FastVector3, scale:FastVector3):Void
	{
		matrix = FastMatrix4.identity();
		matrix = matrix.multmat(FastMatrix4.translation(position.x, position.y, position.z));

		if (rotation.x != 1)
			matrix = matrix.multmat(FastMatrix4.rotationX(rotation.x));

		if (rotation.y != 1)
			matrix = matrix.multmat(FastMatrix4.rotationY(rotation.y));

		if (rotation.z != 1)
			matrix = matrix.multmat(FastMatrix4.rotationZ(rotation.z));

		matrix = matrix.multmat(FastMatrix4.scale(scale.x, scale.y, scale.z));		

		if (Engine.lightLevel > 0)
			updateNormalMatrix();

		matrixDirty = false;
	}

	public function updateNormalMatrix():Void
	{
		var normalMat3 = getMatrix3().inverse().transpose();
		normalMatrix = new FastMatrix4(normalMat3._00, normalMat3._10, normalMat3._20, 1,
										normalMat3._01, normalMat3._11, normalMat3._21, 1,
										normalMat3._02, normalMat3._12, normalMat3._22, 1,
										1, 1, 1, 1);
	}

	public function updateDirections():Void
	{
		forwardDirection = new FastVector3(
			Math.cos(rotation.x) * Math.sin(rotation.y),
			Math.sin(rotation.x),
			Math.cos(rotation.x) * Math.cos(rotation.y)
		);

		rightDirection = new FastVector3(
			Math.sin(rotation.y - 3.14 / 2.0), 
			0,
			Math.cos(rotation.y - 3.14 / 2.0)
		);

		upDirection = rightDirection.cross(forwardDirection);
	}

	/**
	 * Move forward using the direction defined in forwardDirection
	 */
	public function moveForward(value:FastFloat):Void
	{
		var v = forwardDirection.mult(value);
		position.value = position.value.add(v);
	}

	/**
	 * Move backward using the direction defined in forwardDirection 
	 */
	public function moveBackward(value:FastFloat):Void 
	{
		var v = forwardDirection.mult(value * -1);
		position.value = position.value.add(v);		
	}

	/**
	 * Move to the right using the direction defined in rightDirection 
	 */
	public function moveToRight(value:FastFloat):Void 
	{
		var v = rightDirection.mult(value);
		position.value = position.value.add(v);
	}

	/**
	 * Move to the left using the direction defined in rightDirection 
	 */
	public function moveToLeft(value:FastFloat):Void 
	{
		var v = rightDirection.mult(value * -1);
		position.value = position.value.add(v);		
	}

	public function getMatrix3():FastMatrix3
	{
		return new FastMatrix3(matrix._00, matrix._10, matrix._20,
								matrix._01, matrix._11, matrix._21,
								matrix._02, matrix._12, matrix._22);
	}

	public function toString(onWindowTitle:Bool = false):Void
	{
		var text = 'pos ${position.x}, ${position.y}, ${position.z} | 
					rot ${rotation.x}, ${rotation.y}, ${rotation.z} | 
					scale ${scale.x}, ${scale.y}, ${scale.z}';

		if (onWindowTitle)
		{
			#if (sys_html5 || sys_debug_html5)
			js.Browser.document.title = text;
			#end
		}
		else		
			trace(text);		
	}
}