package sd3;

import kha.FastFloat;
import kha.Canvas;
import kha.System;
import sd3.input.Keyboard;
import sd3.input.Mouse;
import sd3.loaders.Loader;
import sd3.internal.MobileBrowser;

#if js
import kha.SystemImpl;
#end

@:structInit
class EngineOptions
{
	public var lightLevel:Int;		
	public var loadDefaultMaterial:Bool;

	public function new(?lightLevel:Null<Int> = 2, ?loadDefaultMaterial:Null<Bool> = true):Void
	{
		this.lightLevel = lightLevel;		
		this.loadDefaultMaterial = loadDefaultMaterial;
	}
}

@:allow(sd3.internal.MobileBrowser)
class Engine
{	
	var camera:Camera;
	var keyboard:Keyboard;
	var mouse:Mouse;

	var sceneList:Map<String, Scene>;
	public static var activeScene:Scene;
		
	public static var gameWidth:Int;
	public static var gameHeight:Int;
	
	public static var lightLevel:Int;
	/**
	 * Indicator of the portrait orientation 
	*/
	public inline static var PORTRAIT:Int = 1;
	/**
	 * Indicator of the landscape orientation 
	 */
	public inline static var LANDSCAPE:Int = 2;
	
	/**
	 * Indicates if the game is running in a mobile browser or desktop (js) 
	 */
	public static var isMobile:Bool = false;

	public static var actualOrientation:Int;

	static var mobile:MobileBrowser;

	public function new(?option:EngineOptions) 
	{		
		gameWidth = System.windowWidth();
		gameHeight = System.windowHeight();

		Loader.init();		

		if (option != null)
		{
			if (option.lightLevel == 3)
			{
				if (isMobile)
					lightLevel = 0;
				else
					lightLevel = 2;
			}
			else
				lightLevel = option.lightLevel;			

			if (option.loadDefaultMaterial)
				Loader.loadDefaultMaterial();			
		}
		else
		{			
			lightLevel = 2;			
			Loader.loadDefaultMaterial();
		}

		keyboard = new Keyboard();
		mouse = new Mouse();
		camera = new Camera();

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

			#if js
			if (mobile != null)
				mobile.update();
			#end
		}		
	}
	
	public function render(canvas:Canvas):Void
	{
		if (activeScene != null)
			activeScene.render(canvas);
	}

	public inline static function setupMobileBrowser():Void
	{
		mobile = new MobileBrowser();
		mobile.setupMobileBrowser();
	}

	#if js
	inline public static function isUsingWebGL():Bool
	{
		return (SystemImpl.gl != null);
	}
	#end
}