#ifdef GL_ES
precision highp float;
#endif

uniform mat4 mvp;

attribute vec3 position;
attribute vec2 textureCoord;
attribute vec3 normal;

varying vec3 vPosition;
varying vec2 vTextureCoord;
varying vec3 vNormal;

void kore()
{
	// Pass some variables to the fragment shader
	vPosition = position;
	vTextureCoord = textureCoord;
    vNormal = normal;
    	
	gl_Position = mvp * vec4(position, 1.0);
}