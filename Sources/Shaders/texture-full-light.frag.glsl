#ifdef GL_ES
precision mediump float;
#endif

#define MAX_LIGHTS 10

uniform mat4 model;
uniform mat4 normalModel;
uniform vec3 cameraPosition;

uniform sampler2D textureSampler;
uniform float materialShininess;
uniform vec3 materialSpecularColor;

uniform int numLights;

uniform vec4 lightPosition[MAX_LIGHTS];
uniform vec3 lightColor[MAX_LIGHTS];
uniform float lightAmbient[MAX_LIGHTS];
uniform float lightAttenuation[MAX_LIGHTS];
uniform float lightConeAngle[MAX_LIGHTS];
uniform vec3 lightConeDirection[MAX_LIGHTS];

varying vec3 vPosition;
varying vec2 vTextureCoord;
varying vec3 vNormal;

vec3 ApplyLight(vec4 lightPositionProp, vec3 lightColorProp, float lightAmbientProp, float lightAttenuationProp, float lightConeAngleProp, vec3 lightConeDirectionProp,
    vec3 surfaceColor, vec3 normal, vec3 surfacePos, vec3 surfaceToCamera) 
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
    vec3 ambient = lightAmbientProp * surfaceColor.rgb * lightColorProp;

    //diffuse
    float diffuseCoefficient = max(0.0, dot(normal, surfaceToLight));
    vec3 diffuse = diffuseCoefficient * surfaceColor.rgb * lightColorProp;
    
    //specular
    float specularCoefficient = 0.0;
    if(diffuseCoefficient > 0.0)
        specularCoefficient = pow(max(0.0, dot(surfaceToCamera, reflect(-surfaceToLight, normal))), materialShininess);
    vec3 specular = specularCoefficient * materialSpecularColor * lightColorProp;

    //linear color (color before gamma correction)
    return ambient + attenuation * (diffuse + specular);
}

void kore()
{
    vec3 normal = normalize(mat3(normalModel) * vNormal);   
    vec3 surfacePosition = vec3(model * vec4(vPosition, 1.0));
    vec4 surfaceColor = texture2D(textureSampler, vTextureCoord);    
    vec3 surfaceToCamera = normalize(cameraPosition - surfacePosition);

    //combine color from all the lights
    vec3 linearColor = vec3(0);    
    
    if (0 < numLights)
        linearColor += ApplyLight(lightPosition[0], lightColor[0], lightAmbient[0], lightAttenuation[0], lightConeAngle[0], lightConeDirection[0], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);
            
    if (1 < numLights)    
        linearColor += ApplyLight(lightPosition[1], lightColor[1], lightAmbient[1], lightAttenuation[1], lightConeAngle[1], lightConeDirection[1], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);

    if (2 < numLights)
        linearColor += ApplyLight(lightPosition[2], lightColor[2], lightAmbient[2], lightAttenuation[2], lightConeAngle[2], lightConeDirection[2], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);

    if (3 < numLights)    
        linearColor += ApplyLight(lightPosition[3], lightColor[3], lightAmbient[3], lightAttenuation[3], lightConeAngle[3], lightConeDirection[3], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);
        
    if (4 < numLights)
        linearColor += ApplyLight(lightPosition[4], lightColor[4], lightAmbient[4], lightAttenuation[4], lightConeAngle[4], lightConeDirection[4], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);

    if (5 < numLights)    
        linearColor += ApplyLight(lightPosition[5], lightColor[5], lightAmbient[5], lightAttenuation[5], lightConeAngle[5], lightConeDirection[5], surfaceColor.rgb, normal, surfacePosition, surfaceToCamera);    

    //final color (after gamma correction)
    
    //vec3 gamma = vec3(1.0 / 2.2);
    //gl_FragColor = vec4(pow(linearColor, gamma), surfaceColor.a);
    
    gl_FragColor = vec4(linearColor, surfaceColor.a);    
}