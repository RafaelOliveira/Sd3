package sd3.internal;

#if js
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import kha.SystemImpl;

@:allow(sd3.Engine)
class MobileBrowser
{
	/**
	 * A div element that is the container of the game canvas (js) 
	 */
	var container:DivElement;	
	/**
	 * The canvas element of the game (js) 
	 */
	var canvas:CanvasElement;

	var actualWidth:Int;

	var actualHeight:Int;	

	function new():Void {}
	
	function setupMobileBrowser():Void
	{
		Engine.isMobile = checkIsMobile();
		setupCanvas();
		Engine.actualOrientation = getOrientation();

		actualWidth = canvas.clientWidth;
		actualHeight = canvas.clientHeight;
	}

	function checkIsMobile():Bool
	{
		var mobile = ['iphone', 'ipad', 'android', 'blackberry', 'nokia', 'opera mini', 'windows mobile', 'windows phone', 'iemobile'];
		for (i in 0...mobile.length)
		{
			if (Browser.navigator.userAgent.toLowerCase().indexOf(mobile[i].toLowerCase()) > 0)
				return true;
		}

		return false;
	}

	function setupCanvas()
	{
		container = cast Browser.document.getElementById('game-container');
		canvas = cast Browser.document.getElementById('khanvas');

		if (Engine.isMobile)
		{
			setHtmlBodyFullscreen();
			
			var w = Std.int(Browser.window.innerWidth);
			var h = Std.int(Browser.window.innerHeight);
			
			if (container != null)
			{
				container.style.width = '${w}px';
				container.style.height = '${h}px';
			}			
			
			canvas.style.width = '${w}px';
			canvas.style.height = '${h}px';
			canvas.width = w;
			canvas.height = h;
		}
		else if (container != null)
		{
			var w = container.clientWidth;
			var h = container.clientHeight;
			
			canvas.style.width = '${w}px';
			canvas.style.height = '${h}px';
			canvas.width = w;
			canvas.height = h;
		}
	}

	function setHtmlBodyFullscreen()
	{
		Browser.document.body.style.margin = '0px';
		Browser.document.body.style.padding = '0px';
		Browser.document.body.style.height = '100%';
		Browser.document.body.style.overflow = 'hidden';
		
		Browser.document.documentElement.style.margin = '0px';
		Browser.document.documentElement.style.padding = '0px';
		Browser.document.documentElement.style.height = '100%';
		Browser.document.documentElement.style.overflow = 'hidden';
	}

	function getOrientation()
	{
		if (canvas.width < canvas.height)
			return Engine.PORTRAIT;
		else
			return Engine.LANDSCAPE;
	}

	function update()
	{
		if (Engine.isMobile && (actualWidth != Browser.window.innerWidth || actualHeight != Browser.window.innerHeight))
		{
			var w = Std.int(Browser.window.innerWidth);
			var h = Std.int(Browser.window.innerHeight);

			if (container != null)
			{
				container.style.width = '${w}px';
				container.style.height = '${h}px';
			}			

			updateCanvas(w, h);
		}
		else if (container != null && !Engine.isMobile && (actualWidth != container.clientWidth || actualHeight != container.clientHeight))		
			updateCanvas(container.clientWidth, container.clientHeight);					
	}

	function updateCanvas(w:Int, h:Int)
	{
		canvas.style.width = '${w}px';
		canvas.style.height = '${h}px';
		canvas.width = w;
		canvas.height = h;

		if (Engine.isUsingWebGL())
			SystemImpl.gl.viewport(0, 0, w, h);	

		actualWidth = w;
		actualHeight = h;
		
		Engine.actualOrientation = getOrientation();

		Engine.gameWidth = w;
		Engine.gameHeight = h;

		if (Engine.actualOrientation != Engine.rotationDeviceOrientation)
			updateScene(Engine.activeScene, w, h);
		else
			updateScene(Engine.rotationDeviceScene, w, h);					
	}

	function updateScene(scene:Scene, w:Int, h:Int):Void
	{
		scene.camera.matrixDirty = true;
		scene.deviceRotated(w, h);
	}
}

#end