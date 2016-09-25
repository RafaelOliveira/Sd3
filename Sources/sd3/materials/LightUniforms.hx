package sd3.materials;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector3;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
import sd3.math.Vec3;

class LightUniforms
{
	inline static var MAX_LIGHTS:Int = 10;

	public var normalModelMatrixId:ConstantLocation;
	public var materialShininessId:ConstantLocation;
	public var materialSpecularColorId:ConstantLocation;

	public var cameraPositionId:ConstantLocation;

	public var lightAmbientCoefficientId:ConstantLocation;
	public var numLightsId:ConstantLocation;	
	public var lightIds:Array<ConstantLocation>;

	public function new(pipeline:PipelineState):Void
	{
		normalModelMatrixId = pipeline.getConstantLocation('normalModel');
		materialShininessId = pipeline.getConstantLocation('materialShininess');	
		materialSpecularColorId = pipeline.getConstantLocation('materialSpecularColor');
		
		cameraPositionId = pipeline.getConstantLocation('cameraPosition');

		//lightAmbientCoefficientId = pipeline.getConstantLocation('lightAmbientCoefficient');
		numLightsId = pipeline.getConstantLocation('numLights');		

		lightIds = new Array<ConstantLocation>();
		for (i in 0...MAX_LIGHTS)
		{
			lightIds.push(pipeline.getConstantLocation('lightPosition[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightColor[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightAmbient[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightAttenuation[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightConeAngle[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightConeDirection[' + i + ']'));
		}
	}

	public function update(g:Graphics, objectShininess:FastFloat, objectSpecularColor:Color, lights:Array<Light>, lightAmbient:FastFloat, cameraPosition:Vec3):Void
	{
		g.setFloat(materialShininessId, objectShininess);
		g.setFloat3(materialSpecularColorId, objectSpecularColor.R, objectSpecularColor.G, objectSpecularColor.B);		
		g.setVector3(cameraPositionId, cameraPosition.value);
		
		//g.setFloat(lightAmbientCoefficientId, lightAmbient);
		g.setInt(numLightsId, lights.length);
		
		var i = 0;
		while(i < lights.length)
		{
			g.setVector4(lightIds[i], lights[i].position);
			g.setVector3(lightIds[i + 1], new FastVector3(lights[i].color.R, lights[i].color.G, lights[i].color.B));
			g.setFloat	(lightIds[i + 2], lights[i].ambient);
			g.setFloat  (lightIds[i + 3], lights[i].attenuation);
			g.setFloat  (lightIds[i + 4], lights[i].coneAngle);
			g.setVector3(lightIds[i + 5], lights[i].coneDirection);
			i += 5;
		}
	}
}