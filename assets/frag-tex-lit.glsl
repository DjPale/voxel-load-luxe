precision mediump float;

// default luxe texture slot
uniform sampler2D tex0;

// from vertex shader
varying vec2 tcoord;
varying float diffuse;

uniform vec4 lightambient;

void main()
{
    vec4 texcolor = texture2D(tex0, tcoord);
    gl_FragColor = texcolor * (vec4(diffuse) + lightambient);
}
