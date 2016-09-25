#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D textureSampler;

varying vec2 vTextureCoord;

void kore()
{	        
    gl_FragColor = texture2D(textureSampler, vTextureCoord);    
}