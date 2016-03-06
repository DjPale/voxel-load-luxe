precision mediump float;
// based on http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/
// and partly https://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf

attribute vec3 vertexPosition;
attribute vec2 vertexTCoord;
attribute vec4 vertexColor;
attribute vec3 vertexNormal;

varying vec2 tcoord;
varying vec4 color;
varying vec3 normal_cameraspace;
varying vec3 lightdir_cameraspace;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 lightpos;
uniform vec4 ambient;

void main(void) {
    vec4 pos_cameraspace = modelViewMatrix * vec4(vertexPosition,1.0);
    vec4 pos = projectionMatrix * modelViewMatrix * vec4(vertexPosition,1.0);

    vec3 eyedir_cameraspace = vec3(0.0,0.0,0.0) - pos_cameraspace.xyz;
    //vec3 lightpos_cameraspace = (modelViewMatrix * vec4(lightpos,1.0)).xyz + eyedir_cameraspace;
    vec3 lightpos_cameraspace = lightpos + eyedir_cameraspace;
    normal_cameraspace = (modelViewMatrix * vec4(vertexNormal,0.0)).xyz;
    lightdir_cameraspace = lightpos_cameraspace + eyedir_cameraspace;
    //float lightdist = distance(pos_cameraspace,vec4(lightpos_cameraspace,1.0));

    vec3 n = normalize(normal_cameraspace);
    vec3 l = normalize(lightdir_cameraspace);
    float diffuse = clamp(dot(n,l),0.0,1.0) ;

    tcoord = vertexTCoord;
    color = vertexColor * vec4(vec3(diffuse) + ambient.rgb, 1.0);

    gl_Position = pos;
    gl_PointSize = 1.0;
}