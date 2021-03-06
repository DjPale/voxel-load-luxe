precision mediump float;
// based on http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/
// and partly https://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf

attribute vec3 vertexPosition;
attribute vec2 vertexTCoord;
attribute vec4 vertexColor;
attribute vec3 vertexNormal;

varying vec2 tcoord;
varying float diffuse;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 lightpos;
uniform float specular;

void main(void)
{
    vec4 pos_cameraspace = modelViewMatrix * vec4(vertexPosition,1.0);
    vec4 pos = projectionMatrix * modelViewMatrix * vec4(vertexPosition,1.0);

    vec3 eyedir_cameraspace = vec3(0.0,0.0,0.0) - pos_cameraspace.xyz;
    vec3 lightpos_cameraspace = (modelViewMatrix * vec4(lightpos,1.0)).xyz;
    vec3 normal_cameraspace = (modelViewMatrix * vec4(vertexNormal,0.0)).xyz;
    vec3 lightdir_cameraspace = lightpos_cameraspace + eyedir_cameraspace;

    vec3 n = normalize(normal_cameraspace);
    vec3 l = normalize(lightdir_cameraspace);

    vec3 E = normalize(eyedir_cameraspace);
    vec3 R = reflect(-l,n);

    diffuse = clamp(dot(n,l),0.0,1.0) + pow(clamp(dot(E,R),0.0,1.0),specular);

    tcoord = vertexTCoord;

    gl_Position = pos;
    gl_PointSize = 1.0;
}
