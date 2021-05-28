shader_type canvas_item;

uniform float width = 0.01;
uniform float progress: hint_range(0.1,0.9) = 0.5;
uniform vec4 color_min: hint_color;
uniform vec4 color_max: hint_color;

float sdSegment( in vec2 p, in vec2 a, in vec2 b ) {
    vec2 pa = p-a, ba = b-a;
    float z = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*z );
}

void fragment() {
	float grayscale = sdSegment(UV, vec2(0.1, 0.5), vec2(0.9, 0.5));
	vec3 lineBackground = vec3(1.0 - smoothstep(width, width + 0.01, grayscale));
	
	float grayscaleForeground = sdSegment(UV, vec2(0.1, 0.5), vec2(progress, 0.5));
	float lineForeground = 1.0 - smoothstep(width, width + 0.01, grayscaleForeground);
	
	vec3 health_color = mix(color_min.rgb, color_max.rgb, progress);
	vec3 bar = mix(lineBackground, health_color.rgb, lineForeground);
	
	COLOR = vec4(bar, 1.0);
}
