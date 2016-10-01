package sd3;

import kha.FastFloat;
import kha.Canvas;
import kha.System;
import sd3.input.Keyboard;
import sd3.input.Mouse;
import sd3.loaders.Loader;

@:structInit
class EngineOptions
{
	public var lightLevel:Int;	
	public var cameraAspect:FastFloat;
	public var loadDefaultMaterial:Bool;

	public function new(?lightLevel:Null<Int> = 2, ?cameraAspect:Null<FastFloat> = 0, ?loadDefaultMaterial:Null<Bool> = true):Void
	{
		this.lightLevel = lightLevel;
		this.cameraAspect = cameraAspect;
		this.loadDefaultMaterial = loadDefaultMaterial;
	}
}

class Engine
{	
	var camera:Camera;
	var keyboard:Keyboard;
	var mouse:Mouse;

	var sceneList:Map<String, Scene>;
	var activeScene:Scene;	
		
	public static var gameWidth:Int;
	public static var gameHeight:Int;
	
	public static var lightLevel:Int;

	public function new(?option:EngineOptions) 
	{
		var cameraAspect:FastFloat;
		
		gameWidth = System.windowWidth();
		gameHeight = System.windowHeight();

		Loader.init();
		
		var desktopAspect = 4.0 / 3.0;

		if (option != null)
		{
			lightLevel = option.lightLevel;
			cameraAspect = option.cameraAspect == 0 ? desktopAspect : option.cameraAspect;

			if (option.loadDefaultMaterial)
				Loader.loadDefaultMaterial();			
		}
		else
		{			
			lightLevel = 2;
			cameraAspect = desktopAspect;
			Loader.loadDefaultMaterial();
		}

		keyboard = new Keyboard();
		mouse = new Mouse();
		camera = new Camera(cameraAspect);

		sceneList = new Map<String, Scene>();		
		activeScene = null;
	}

	public function addScene(name:String, scene:Scene, setActive:Bool = false):Void
	{
		sceneList.set(name, scene);

		if (setActive)
			activeScene = scene;		
	}

	public function removeScene(name:String):Void
	{
		sceneList.remove(name);
	}

	public function setActiveScene(name:String):Void
	{
		activeScene = sceneList.get(name);
	}
	
	public function update():Void
	{
		if (activeScene != null)
		{
			activeScene.update();
			
			keyboard.update();
			mouse.update();
			camera.update();			

			mouse.postUpdate();
		}		
	}
	
	public function render(canvas:Canvas):Void
	{
		if (activeScene != null)
			activeScene.render(canvas);
	}
}