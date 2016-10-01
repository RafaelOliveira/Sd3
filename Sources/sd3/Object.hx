package sd3;

import kha.Color;
import kha.Image;
import kha.FastFloat;
import kha.graphics4.Graphics;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFilter;
import kha.graphics4.MipMapFilter;
import sd3.materials.Material;
import sd3.Model.ModelType;
import sd3.loaders.Loader;
import sd3.components.Component;

class Object extends Transform
{
	/**
	 * If the object can update 
	 */ 
	public var active:Bool;
	/**
	 * If the object should render
	 */
	public var visible:Bool;

	public var model:Model;
	public var material:Material;
	public var camera:Camera;
	public var scene:Scene;

	public var shininess:FastFloat;
	public var specularColor:Color;
	/**
	 * Components that updates and affect the object
	 */
	public var components:Array<Component>;

	var image:Image;

	public function new(modelType:ModelType, image:Image, ?material:Material):Void
	{
		super();

		switch(modelType.type)
		{
			case Left(s):
				this.model = Loader.getModel(s);

			case Right(m):
				this.model = m;
		}

		active = true;
		visible = true;

		this.image = image;
		
		this.material = material == null ? Loader.getMaterial() : material;

		camera = Camera.get();

		shininess = 80.0;
		specularColor = Color.White;

		components = new Array<Component>();	

		if (Engine.lightLevel > 0)
			updateNormalMatrix();
	}

	public function addComponent(comp:Component)
	{
		components.push(comp);
		comp.object = this;
		comp.init();
	}

	inline public function removeComponent(comp:Component)
	{
		components.remove(comp);
	}

	override public function update():Void
	{
		if (!active)
			return;

		if (matrixDirty)
		{
			updateDirections();
			updateMatrix(position.value, rotation.value, scale.value);
		}

		for (comp in components)
		{
			if (comp.active)
				comp.update();
		}
	}

	/**
	 * Sets the vertexBuffer, indexBuffer and pipeline
	 * to the Graphics. Use this in the render function
	 */
	public function setMaterialAndBuffers(g:Graphics):Void
	{
		// Bind data we want to draw
		g.setVertexBuffer(model.vertexBuffer);
		g.setIndexBuffer(model.indexBuffer);

		// Bind state we want to draw with
		g.setPipeline(material.pipeline);
		
		if (Engine.lightLevel > 0)			
			g.setMatrix(material.modelMatrixId, matrix);

		// Set texture
		if (image != null)
		{
			g.setTexture(material.textureId, image);

			g.setTextureParameters(material.textureId, TextureAddressing.Clamp, TextureAddressing.Clamp,
				TextureFilter.PointFilter, TextureFilter.PointFilter, MipMapFilter.NoMipFilter);
		}			

		if (Engine.lightLevel > 0)
			g.setMatrix(material.lightUniforms.normalModelMatrixId, normalMatrix);
	}
}