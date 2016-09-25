#ifdef GL_ES
precision highp float;
#endif

uniform mat4 mvp;

attribute vec3 position;
attribute vec2 textureCoord;

varying vec2 vTextureCoord;

void kore()
{
	// Pass some variables to the fragment shader	
	vTextureCoord = textureCoord;    
    	
	gl_Position = mvp * vec4(position, 1.0);
}