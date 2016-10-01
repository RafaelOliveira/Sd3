package sd3.loaders;

import kha.Shaders;
import kha.Blob;
import kha.math.FastVector3;
import kha.graphics4.VertexData;
import sd3.materials.Material;

class Loader
{
	static var materialCache:Map<String, Material>;
	static var modelCache:Map<String, Model>;

	public static function init():Void
	{
		materialCache = new Map<String, Material>();
		modelCache = new Map<String, Model>();
	}

	public static function loadDefaultMaterial():Void
	{		
		if (Engine.lightLevel == 2)
		{
			var materialName = 'texture-full-light';						
			
			var material = new Material(Shaders.texture_full_light_vert, Shaders.texture_full_light_frag);
			material.bindAttribute('textureCoord', VertexData.Float2);
			material.bindAttribute('normal', VertexData.Float3);
			material.textureId = material.getTextureUnit('textureSampler');

			materialCache.set('default', material);			
		}
		else if (Engine.lightLevel == 1)
		{
			var materialName = 'texture-basic-light';						
			
			var material = new Material(Shaders.texture_basic_light_vert, Shaders.texture_basic_light_frag);
			material.bindAttribute('textureCoord', VertexData.Float2);
			material.bindAttribute('normal', VertexData.Float3);
			material.textureId = material.getTextureUnit('textureSampler');

			materialCache.set('default', material);			
		}
		else
		{
			var materialName = 'texture-no-light';					
			
			var material = new Material(Shaders.texture_no_light_vert, Shaders.texture_no_light_frag);
			material.bindAttribute('textureCoord', VertexData.Float2);				
			material.textureId = material.getTextureUnit('textureSampler');

			materialCache.set('default', material);			
		}
	}

	public static function saveMaterial(name:String, material:Material):Void
	{
		if (name != 'default')
			materialCache.set(name, material);
		else
		{
			trace('The name "default" is a reserved name for the default material.');
			trace('Please use another name for the material that you are saving.');
		}
	}

	public static function getMaterial(?name:String):Material
	{
		if (name != null)
			return materialCache.get(name);
		else
			return materialCache.get('default');
	}

	public static function saveModel(name:String, model:Model):Void
	{
		modelCache.set(name, model);
	}	

	public static function getModel(name:String):Model
	{
		return modelCache.get(name);
	}

	public static function loadModel(name:String, file:Blob, ?material:Material):Model
	{
		if (material == null)
			material = materialCache.get('default');

		var model = loadModelFromFile(file, material);
		saveModel(name, model);

		return model;
	}

	public static function loadModelFromFile(file:Blob, ?material:Material):Model
	{
		if (material == null)
			material = materialCache.get('default');
			
		var modelData = new ObjLoader(file.toString());
		var model = new Model(material, modelData.data, modelData.indices);
		model.size = modelData.size;
		model.halfSize = new FastVector3(model.size.x / 2, model.size.y / 2, model.size.z / 2);

		return model;
	}
}