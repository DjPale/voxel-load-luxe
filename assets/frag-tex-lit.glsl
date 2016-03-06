precision mediump float;

// default luxe texture slot
uniform sampler2D tex0;

// from vertex shader
varying vec2 tcoord;
varying vec4 color;

void main() {
    vec4 texcolor = texture2D(tex0, tcoord);
    gl_FragColor = color * texcolor;
}
