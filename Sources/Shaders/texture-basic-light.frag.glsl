#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D textureSampler;

varying vec3 vLinearColor;
varying vec2 vTextureCoord;

void kore()
{	        
    vec4 surfaceColor = texture2D(textureSampler, vTextureCoord);

    gl_FragColor = vec4(surfaceColor.rgb * vLinearColor, surfaceColor.a);
}