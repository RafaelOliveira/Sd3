package sd3;

import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.System;
import kha.Scaler;
import sd3.input.Keyboard;
import sd3.input.Mouse;

@:structInit
class EngineOptions
{
	public var lightLevel:Int;
	public var backbuffer:Bool;
	public var backbufferWidth:Int;
	public var backbufferHeight:Int;

	public function new(?lightLevel:Null<Int> = 2, ?backbuffer:Null<Bool> = false, ?backbufferWidth:Null<Int> = 0, ?backbufferHeight:Null<Int> = 0):Void
	{
		this.lightLevel = lightLevel;
		this.backbuffer = backbuffer;
		this.backbufferWidth = backbufferWidth;
		this.backbufferHeight = backbufferHeight;
	}
}

class Engine
{	
	var camera:Camera;
	var keyboard:Keyboard;
	var mouse:Mouse;

	var sceneList:Map<String, Scene>;
	var activeScene:Scene;

	var backbuffer:Image;
	
	public static var windowWidth:Int;
	public static var windowHeight:Int;
	public static var gameWidth:Int;
	public static var gameHeight:Int;
	
	public static var lightLevel:Int;

	public function new(?option:EngineOptions) 
	{
		windowWidth = System.windowWidth();
		windowHeight = System.windowHeight();

		if (option != null)
		{
			lightLevel = option.lightLevel;

			if (option.backbuffer)
			{
				gameWidth = option.backbufferWidth == 0 ? windowWidth : option.backbufferWidth;
				gameHeight = option.backbufferHeight == 0 ? windowHeight : option.backbufferHeight;		

				backbuffer = Image.createRenderTarget(gameWidth, gameHeight);
			}
		}
		else		
			lightLevel = 2;

		if (backbuffer == null)
		{
			gameWidth = windowWidth;
			gameHeight = windowHeight;
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
		}		
	}
	
	public function render(canvas:Canvas):Void
	{
		if (activeScene != null)
		{
			if (backbuffer != null)
			{
				activeScene.render(backbuffer);

				canvas.g2.begin(true, Color.Black);
				//Scaler.scale(backbuffer, canvas, System.screenRotation);
				canvas.g2.drawScaledSubImage(backbuffer, 0, 0, gameWidth, gameHeight, 0, 0, windowWidth, windowHeight);				
				canvas.g2.end();
			}
			else
				activeScene.render(canvas);
		}					
	}
}