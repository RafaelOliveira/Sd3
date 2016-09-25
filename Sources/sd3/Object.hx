package sd3;

import kha.Color;
import kha.Image;
import kha.FastFloat;
import kha.graphics4.Graphics;
import sd3.materials.Material;

class Object extends Transform
{
	public var model:Model;
	public var material:Material;
	public var camera:Camera;
	public var scene:Scene;

	public var shininess:FastFloat;
	public var specularColor:Color;

	var image:Image;

	public function new(model:Model, material:Material, image:Image):Void
	{
		super();

		this.model = model;
		this.material = material;

		camera = Camera.get();

		shininess = 80.0;
		specularColor = Color.White;

		this.image = image;

		if (Engine.lightLevel > 0)
			updateNormalMatrix();
	}

	override public function update():Void
	{
		if (matrixDirty)
		{
			updateDirections();
			updateMatrix(position.value, rotation.value, scale.value);
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

		g.setMatrix(material.modelMatrixId, matrix);

		// Set texture
		if (image != null)
			g.setTexture(material.textureId, image);

		if (Engine.lightLevel > 0)
			g.setMatrix(material.lightUniforms.normalModelMatrixId, normalMatrix);
	}
}