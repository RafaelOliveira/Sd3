package sd3.materials;

import haxe.ds.Vector;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector3;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.ConstantLocation;
import sd3.math.Vec3;

class LightUniforms
{
	inline static var MAX_LIGHTS:Int = 5;

	public var normalModelMatrixId:ConstantLocation;
	public var materialShininessId:ConstantLocation;
	public var materialSpecularColorId:ConstantLocation;

	public var cameraPositionId:ConstantLocation;
	
	public var numLightsId:ConstantLocation;	
	//public var lightIds:Array<ConstantLocation>;
	
	public var lightPosition:ConstantLocation;
	public var lightColor:ConstantLocation;
	public var lightAmbient:ConstantLocation;
	public var lightAttenuation:ConstantLocation;
	public var lightConeAngle:ConstantLocation;
	public var lightConeDirection:ConstantLocation;
	
	var lightPositionList:Vector<FastFloat>;
	var lightColorList:Vector<FastFloat>;
	var lightAmbientList:Vector<FastFloat>;
	var lightAttenuationList:Vector<FastFloat>;
	var lightConeAngleList:Vector<FastFloat>;
	var lightConeDirectionList:Vector<FastFloat>;

	public function new(pipeline:PipelineState):Void
	{
		normalModelMatrixId = pipeline.getConstantLocation('normalModel');
		materialShininessId = pipeline.getConstantLocation('materialShininess');	
		materialSpecularColorId = pipeline.getConstantLocation('materialSpecularColor');
		
		cameraPositionId = pipeline.getConstantLocation('cameraPosition');
		
		numLightsId = pipeline.getConstantLocation('numLights');
		//lightIds = new Array<ConstantLocation>();
		
		/*for (i in 0...MAX_LIGHTS)
		{
			lightIds.push(pipeline.getConstantLocation('lightPosition[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightColor[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightAmbient[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightAttenuation[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightConeAngle[' + i + ']'));
			lightIds.push(pipeline.getConstantLocation('lightConeDirection[' + i + ']'));
		}*/
		
		lightPosition = pipeline.getConstantLocation('lightPosition');
		lightColor = pipeline.getConstantLocation('lightColor');
		lightAmbient = pipeline.getConstantLocation('lightAmbient');
		lightAttenuation = pipeline.getConstantLocation('lightAttenuation');
		lightConeAngle = pipeline.getConstantLocation('lightConeAngle');
		lightConeDirection = pipeline.getConstantLocation('lightConeDirection');
		
		var initialNumLights = 2;
		
		lightPositionList = 		new Vector<FastFloat>(initialNumLights * 4);
		lightColorList = 			new Vector<FastFloat>(initialNumLights * 3);
		lightAmbientList = 			new Vector<FastFloat>(initialNumLights);
		lightAttenuationList = 		new Vector<FastFloat>(initialNumLights);
		lightConeAngleList = 		new Vector<FastFloat>(initialNumLights);
		lightConeDirectionList = 	new Vector<FastFloat>(initialNumLights * 3);
	}

	public function update(g:Graphics, objectShininess:FastFloat, objectSpecularColor:Color, lights:Array<Light>, cameraPosition:Vec3):Void
	{
		g.setFloat(materialShininessId, objectShininess);
		g.setFloat3(materialSpecularColorId, objectSpecularColor.R, objectSpecularColor.G, objectSpecularColor.B);		
		g.setVector3(cameraPositionId, cameraPosition.value);
			
		g.setInt(numLightsId, lights.length);
		
		var i = 0;
		
		for (light in lights)
		{
			lightPositionList[i + 0] = light.position.x;
			lightPositionList[i + 1] = light.position.y;
			lightPositionList[i + 2] = light.position.z;
			lightPositionList[i + 3] = light.position.w;
			
			lightColorList[i + 0] = light.color.R;
			lightColorList[i + 1] = light.color.G;
			lightColorList[i + 2] = light.color.B;
			
			lightAmbientList[i] = light.ambient;
			
			lightAttenuationList[i] = light.attenuation;
			
			lightConeAngleList[i] = light.coneAngle;
			
			lightConeDirectionList[i + 0] = light.coneDirection.x;
			lightConeDirectionList[i + 1] = light.coneDirection.y;
			lightConeDirectionList[i + 2] = light.coneDirection.z;
			
			i += 13;
			
			/*g.setVector4(lightIds[i], lights[i].position);
			g.setVector3(lightIds[i + 1], new FastVector3(lights[i].color.R, lights[i].color.G, lights[i].color.B));
			g.setFloat	(lightIds[i + 2], lights[i].ambient);
			g.setFloat  (lightIds[i + 3], lights[i].attenuation);
			g.setFloat  (lightIds[i + 4], lights[i].coneAngle);
			g.setVector3(lightIds[i + 5], lights[i].coneDirection);
			i += 5;*/
		}
		
		g.setFloats(lightPosition, lightPositionList);
		g.setFloats(lightColor, lightColorList);
		g.setFloats(lightAmbient, lightAmbientList);
		g.setFloats(lightAttenuation, lightAttenuationList);
		g.setFloats(lightConeAngle, lightConeAngleList);
		g.setFloats(lightConeDirection, lightConeDirectionList);
	}
}