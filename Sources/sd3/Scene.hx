package sd3;

import kha.Color;
import kha.Image;
import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.Canvas;
import sd3.objects2d.Object2d;

class Scene
{
	public var objects:Array<Object>;
	public var objects2d:Array<Object2d>;

	public var camera:Camera;
	var lights:Array<Light>;	

	var bgColor:Color;
	var bgImage:Image;

	public function new():Void
	{
		objects = new Array<Object>();
		objects2d = new Array<Object2d>();

		camera = new Camera();
		lights = new Array<Light>();		

		bgColor = Color.Black;
	}

	public function begin():Void {}	

	public function deviceRotated(width:Int, height:Int):Void {}

	public function update():Void
	{
		for (object in objects)
		{
			if (object.active)
				object.update();
		}
		
		for (object2d in objects2d)
		{
			if (object2d.active)
				object2d.update();
		}
	}

	public function add(object:Object):Object
	{
		object.scene = this;
		objects.push(object);

		object.added();

		return object;
	}

	public function add2d(object2d:Object2d):Object2d
	{
		object2d.scene = this;
		objects2d.push(object2d);

		return object2d;
	}

	public function remove(object:Object):Void
	{
		object.scene = null;
		objects.remove(object);
	}

	public function remove2d(object2d:Object2d):Void
	{
		object2d.scene = null;
		objects2d.remove(object2d);
	}

	public function addLight(light:Light):Light
	{		
		lights.push(light);

		return light;
	}

	public function removeLight(light:Light):Void
	{
		lights.remove(light);
	}

	public inline function render(canvas:Canvas):Void
	{
		var g4 = canvas.g4;
		var g2 = canvas.g2;

		if (bgImage != null)
		{
			g2.begin(true, Color.Black);
			g2.drawScaledSubImage(bgImage, 0, 0, bgImage.width, bgImage.height, 0, 0, Engine.gameWidth, Engine.gameHeight);
			g2.end();
			
			g4.begin();			
			g4.clear(null, 1);			
		}
		else
		{			
			g4.begin();
			g4.clear(bgColor, 1);
		}
		
		for (object in objects)
		{
			if (object.visible)
			{
				object.setMaterialAndBuffers(g4);
			
				var mvp = FastMatrix4.identity();
				mvp = mvp.multmat(camera.matrix);
				mvp = mvp.multmat(object.matrix);			
				
				// Send our transformation to the currently bound shader, in the "mvp" uniform
				g4.setMatrix(object.material.getConstantLocation('mvp'), mvp);

				if (Engine.lightLevel > 0) //&& lights.length > 0)
					object.material.lightUniforms.update(g4, object.shininess, object.specularColor, lights, camera.position);
				
				g4.drawIndexedVertices();
			}			
		}

		g4.end();

		if (objects2d.length > 0)
		{
			g2.begin(false);
			for (object2d in objects2d)
			{
				if (object2d.visible)
					object2d.render(g2);
			}
			g2.end();
		}
	}	
}