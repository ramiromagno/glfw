#version 330 core

uniform vec2 u_resolution;
uniform float u_time;
out vec4 FragColor;

void main() {
	FragColor = vec4(abs(sin(u_time)),0.0,0.0,1.0);
}
