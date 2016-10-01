package sd3.components;

import kha.math.FastVector3;

class Motion extends Component
{
	public var velocity:FastVector3;
	public var maxVelocity:FastVector3;
	public var acceleration:FastVector3;
	public var drag:FastVector3;
	
	public function new() 
	{
		super();
		
		velocity = new FastVector3();
		acceleration = new FastVector3();
		drag = new FastVector3();
		maxVelocity = new FastVector3(10000, 10000, 10000);
	}	
	
	override public function update():Void
	{	
		velocity.x = computeVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x);
		velocity.y = computeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y);
		velocity.z = computeVelocity(velocity.z, acceleration.z, drag.z, maxVelocity.z);
	}

	function computeVelocity(compVelocity:Float, compAcceleration:Float, compDrag:Float, compMaxVelocity:Float):Float
	{
		if (compAcceleration != 0)
			compVelocity += compAcceleration;
		else if (compDrag != 0)
		{
			if (compVelocity - compDrag > 0)
			{
				compVelocity -= compDrag;
			}
			else if (compVelocity + compDrag < 0)
			{
				compVelocity += compDrag;
			}
			else			
				compVelocity = 0;			
		}

		if ((compVelocity != 0) && (compMaxVelocity != 0))
		{
			if (compVelocity > compMaxVelocity)			
				compVelocity = compMaxVelocity;			
			else if (compVelocity < -compMaxVelocity)			
				compVelocity = -compMaxVelocity;			
		}
		return compVelocity;
	}
}