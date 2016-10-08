package sd3;

import kha.FastFloat;
import kha.Canvas;
import kha.System;
import sd3.input.Keyboard;
import sd3.input.Mouse;
import sd3.input.Touch;
import sd3.loaders.Loader;
import sd3.internal.MobileBrowser;

#if js
import kha.SystemImpl;
#end

@:structInit
class EngineOptions
{
	public var lightLevel:Int;
	public var smoothTextureFilter:Bool;
	public var loadDefaultMaterial:Bool;
	
	public function new(?lightLevel:Null<Int> = 2, ?smoothTextureFilter:Null<Bool> = true, ?loadDefaultMaterial:Null<Bool> = true):Void
	{
		this.lightLevel = lightLevel;		
		this.smoothTextureFilter = smoothTextureFilter;
		this.loadDefaultMaterial = loadDefaultMaterial;		
	}
}

@:allow(sd3.internal.MobileBrowser)
class Engine
{	
	var keyboard:Keyboard;
	var mouse:Mouse;
	var touch:Touch;

	var sceneList:Map<String, Scene>;
	public static var activeScene:Scene;
		
	public static var gameWidth:Int;
	public static var gameHeight:Int;
	
	public static var lightLevel(default, null):Int;

	public static var smoothTextureFilter(default, null):Bool;
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
	static var rotationDeviceOrientation:Int = 0;
	static var rotationDeviceScene:Scene;	

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

			smoothTextureFilter = option.smoothTextureFilter;

			if (option.loadDefaultMaterial)
				Loader.loadDefaultMaterial();
		}
		else
		{			
			lightLevel = 2;
			smoothTextureFilter = true;
			Loader.loadDefaultMaterial();
		}

		keyboard = new Keyboard();

		if (!isMobile)
			mouse = new Mouse();
		else
			touch = new Touch();		

		sceneList = new Map<String, Scene>();		
		activeScene = null;
	}

	public function addScene(name:String, scene:Scene, setActive:Bool = false):Void
	{
		sceneList.set(name, scene);

		if (setActive)
		{
			activeScene = scene;
			activeScene.begin();
		}			
	}

	public function removeScene(name:String):Void
	{
		sceneList.remove(name);
	}

	public function setActiveScene(name:String):Void
	{
		activeScene = sceneList.get(name);
		activeScene.begin();
	}

	public function setRotationDeviceScene(rotationDeviceScene:Scene, rotationDeviceOrientation:Int):Void
	{		
			Engine.rotationDeviceScene = rotationDeviceScene;
			Engine.rotationDeviceOrientation = rotationDeviceOrientation;
								
	}
	
	public function update():Void
	{
		#if js
		if (rotationDeviceOrientation == actualOrientation)
		{
			rotationDeviceScene.update();
			rotationDeviceScene.camera.update();

			if (mobile != null)
				mobile.update();
		}			
		else if (activeScene != null)
		{
			updateActiveScene();

			if (mobile != null)
				mobile.update();
		}		
		#else
		if (activeScene != null)
			updateActiveScene();		
		#end
	}

	function updateActiveScene()
	{
		activeScene.update();
							
		keyboard.update();

		if (!isMobile)
			mouse.update();
		else
			touch.update();

		activeScene.camera.update();			

		if (!Engine.isMobile)
			mouse.postUpdate();
	}
	
	public function render(canvas:Canvas):Void
	{
		#if js
		if (rotationDeviceOrientation == actualOrientation)
			rotationDeviceScene.render(canvas);
		else if (activeScene != null)
			activeScene.render(canvas);
		#else
		if (activeScene != null)
			activeScene.render(canvas);
		#end
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