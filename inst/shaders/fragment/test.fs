// Author: Inigo Quiles
// Title: Expo

#version 330 core
#define PI 3.14159265359

uniform vec2 resolution;
uniform int w;
uniform int h;

uniform vec2 u_mouse;
uniform float u_time;

out vec4 FragColor;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy / resolution.xy;

    float y = pow(st.x,5.0);

    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    //color = vec3(0, gl_FragCoord.x / float(w), gl_FragCoord.y / float(h));
    color = vec3(0, st.x, st.y);
    FragColor = vec4(color, 1.0);

/*
    //st = gl_FragCoord.xy / u_resolution;
    if (resolution.x > 199.) {
      FragColor = vec4(1, 0, 0, 1.0); // red
    } else {
      FragColor = vec4(0, 1, 0, 1.0); // green
    }
*/
}
