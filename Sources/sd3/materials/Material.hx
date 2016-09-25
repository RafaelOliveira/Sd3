package sd3.materials;

import kha.Shaders;
import kha.graphics4.Graphics;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;
import kha.graphics4.ConstantLocation;
import kha.graphics4.TextureUnit;

class Material
{
	static var cache:Map<String, Material>;

	public var pipeline:PipelineState;	
	/**
	 * Structure that maintain the attributes
	 */
	public var structure:VertexStructure;
	/**
	 * The size of all the attributes
	 */
	public var structureLength:Int;	
	/**
	 * The sizes of the attributes, in order
	 */	
	public var structureSizes:Array<Int>;

	// uniforms
	public var modelMatrixId:ConstantLocation;

	public var lightUniforms:LightUniforms;	
	
	public var textureId:TextureUnit;
	
	public function new(vertexShader:VertexShader, fragmentShader:FragmentShader):Void
	{
		// Structure data
		structure = new VertexStructure();
		structureLength = 0;
		structureSizes = new Array<Int>();
		
		bindAttribute('position', VertexData.Float3);

		// Pipeline state
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		
		setShaders(vertexShader, fragmentShader);

		// uniforms
		modelMatrixId = getConstantLocation('model');

		if (Engine.lightLevel > 0)
			lightUniforms = new LightUniforms(pipeline);				
	}	
		
	public function bindAttribute(name:String, vertexData:VertexData):Void
	{
		structure.add(name, vertexData);

		switch(vertexData)
		{
			case VertexData.Float1:
				structureLength += 1;
				structureSizes.push(1);

			case VertexData.Float2:
				structureLength += 2;
				structureSizes.push(2);

			case VertexData.Float3:
				structureLength += 3;
				structureSizes.push(3);

			case VertexData.Float4:
				structureLength += 4;
				structureSizes.push(4);

			default:
		}
	}	

	public function setShaders(?vertexShader:VertexShader, ?fragmentShader:FragmentShader):Void
	{
		if (vertexShader != null)
			pipeline.vertexShader = vertexShader;

		if (fragmentShader != null)	
			pipeline.fragmentShader = fragmentShader;
			
		// Set depth mode
        pipeline.depthWrite = true;
        pipeline.depthMode = CompareMode.Less;
        // Set culling
        pipeline.cullMode = CullMode.Clockwise;

		pipeline.compile();
	}
	
	inline public function getTextureUnit(name:String):TextureUnit
	{
		return pipeline.getTextureUnit(name);
	}
	
	inline public function getConstantLocation(name:String):ConstantLocation
	{
		return pipeline.getConstantLocation(name);
	}

	public static function get():Material
	{		
		var material:Material = null;
		var materialName:String;

		if (cache == null)		
			cache = new Map<String, Material>();

		if (Engine.lightLevel == 2)
		{
			materialName = 'texture-full-light';
			material = cache.get(materialName);
			
			if (material == null)
			{
				material = new Material(Shaders.texture_full_light_vert, Shaders.texture_full_light_frag);
				material.bindAttribute('textureCoord', VertexData.Float2);
				material.bindAttribute('normal', VertexData.Float3);
				material.textureId = material.getTextureUnit('textureSampler');

				cache.set(materialName, material);
			}
		}
		else if (Engine.lightLevel == 1)
		{
			materialName = 'texture-basic-light';
			material = cache.get(materialName);
			
			if (material == null)
			{
				material = new Material(Shaders.texture_basic_light_vert, Shaders.texture_basic_light_frag);
				material.bindAttribute('textureCoord', VertexData.Float2);
				material.bindAttribute('normal', VertexData.Float3);
				material.textureId = material.getTextureUnit('textureSampler');

				cache.set(materialName, material);
			}
		}
		else
		{
			materialName = 'texture-no-light';
			material = cache.get(materialName);
			
			if (material == null)
			{
				material = new Material(Shaders.texture_no_light_vert, Shaders.texture_no_light_frag);
				material.bindAttribute('textureCoord', VertexData.Float2);				
				material.textureId = material.getTextureUnit('textureSampler');

				cache.set(materialName, material);
			}
		}
			
		return material;		
	}
}