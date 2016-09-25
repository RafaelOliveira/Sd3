#ifdef GL_ES
precision highp float;
#endif

#define MAX_LIGHTS 10

uniform mat4 mvp;
uniform mat4 model;
uniform mat4 normalModel;
uniform vec3 cameraPosition;

//uniform sampler2D textureSampler;
uniform float materialShininess;
uniform vec3 materialSpecularColor;

uniform int numLights;

uniform vec4 lightPosition[MAX_LIGHTS];
uniform vec3 lightColor[MAX_LIGHTS];
uniform float lightAmbient[MAX_LIGHTS];
uniform float lightAttenuation[MAX_LIGHTS];
uniform float lightConeAngle[MAX_LIGHTS];
uniform vec3 lightConeDirection[MAX_LIGHTS];

attribute vec3 position;
attribute vec2 textureCoord;
attribute vec3 normal;

varying vec3 vLinearColor;
varying vec2 vTextureCoord;

vec3 ApplyLight(vec4 lightPositionProp, vec3 lightColorProp, float lightAmbientProp, float lightAttenuationProp, float lightConeAngleProp, vec3 lightConeDirectionProp,
    vec3 normal, vec3 surfacePos, vec3 surfaceToCamera) 
{
    vec3 surfaceToLight;
    float attenuation = 1.0;
    if (lightPositionProp.w == 0.0) 
    {
        //directional light
        surfaceToLight = normalize(lightPositionProp.xyz);
        attenuation = 1.0; //no attenuation for directional lights
    }
    else
    {
        //point light
        surfaceToLight = normalize(lightPositionProp.xyz - surfacePos);
        float distanceToLight = length(lightPositionProp.xyz - surfacePos);
        attenuation = 1.0 / (1.0 + lightAttenuationProp * pow(distanceToLight, 2.0));

        //cone restrictions (affects attenuation)
        float lightToSurfaceAngle = acos(dot(-surfaceToLight, normalize(lightConeDirectionProp)));
        if(lightToSurfaceAngle > lightConeAngleProp)
        {
            attenuation = 0.0;
        }
    }

    //ambient
    //vec3 ambient = lightAmbientProp * surfaceColor.rgb * lightColorProp;
    vec3 ambient = lightAmbientProp * lightColorProp;

    //diffuse
    float diffuseCoefficient = max(0.0, dot(normal, surfaceToLight));
    //vec3 diffuse = diffuseCoefficient * surfaceColor.rgb * lightColorProp;
    vec3 diffuse = diffuseCoefficient * lightColorProp;
    
    //specular
    float specularCoefficient = 0.0;
    if(diffuseCoefficient > 0.0)
        specularCoefficient = pow(max(0.0, dot(surfaceToCamera, reflect(-surfaceToLight, normal))), materialShininess);
    vec3 specular = specularCoefficient * materialSpecularColor * lightColorProp;

    //linear color (color before gamma correction)
    return ambient + attenuation * (diffuse + specular);
    //return ambient + attenuation * diffuse;
}

void kore()
{
	vec3 vNormal = normalize(mat3(normalModel) * normal);   
    vec3 surfacePosition = vec3(model * vec4(position, 1.0));
    //vec4 surfaceColor = texture2D(textureSampler, textureCoord);    
    vec3 surfaceToCamera = normalize(cameraPosition - surfacePosition);

    //combine color from all the lights
    vec3 linearColor = vec3(0);    
    
    if (0 < numLights)
        linearColor += ApplyLight(lightPosition[0], lightColor[0], lightAmbient[0], lightAttenuation[0], lightConeAngle[0], lightConeDirection[0], normal, surfacePosition, surfaceToCamera);
            
    if (1 < numLights)    
        linearColor += ApplyLight(lightPosition[1], lightColor[1], lightAmbient[1], lightAttenuation[1], lightConeAngle[1], lightConeDirection[1], normal, surfacePosition, surfaceToCamera);

    if (2 < numLights)
        linearColor += ApplyLight(lightPosition[2], lightColor[2], lightAmbient[2], lightAttenuation[2], lightConeAngle[2], lightConeDirection[2], normal, surfacePosition, surfaceToCamera);

    if (3 < numLights)    
        linearColor += ApplyLight(lightPosition[3], lightColor[3], lightAmbient[3], lightAttenuation[3], lightConeAngle[3], lightConeDirection[3], normal, surfacePosition, surfaceToCamera);
        
    if (4 < numLights)
        linearColor += ApplyLight(lightPosition[4], lightColor[4], lightAmbient[4], lightAttenuation[4], lightConeAngle[4], lightConeDirection[4], normal, surfacePosition, surfaceToCamera);

    if (5 < numLights)    
        linearColor += ApplyLight(lightPosition[5], lightColor[5], lightAmbient[5], lightAttenuation[5], lightConeAngle[5], lightConeDirection[5], normal, surfacePosition, surfaceToCamera);
	
	//vLinearColor = vec4(linearColor, surfaceColor.a);    
    vLinearColor = linearColor;
    vTextureCoord = textureCoord;
    	
	gl_Position = mvp * vec4(position, 1.0);
}