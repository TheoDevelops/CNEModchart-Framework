//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
#define time iTime
//SHADERTOY PORT FIX

#define _Amount 0.13
#define _Frequency 1.5
#define _JitterIntensity 0.45
    
float randomNoise(float x, float y)
{
	return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}
    
void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

	float strength = 0.5 + 0.5 * cos(iTime * _Frequency);	
	float jitter = randomNoise(uv.y, iTime) * 2.0 - 1.0;
    float threshold = clamp(1.0f - _JitterIntensity * 1.2f, 0.0, 1.0);
	jitter *= step(threshold, abs(jitter)) * _Amount * strength;	

    // Output to screen
    fragColor = texture(iChannel0, fract(uv + vec2(jitter, 1)));	
}