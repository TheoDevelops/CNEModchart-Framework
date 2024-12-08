#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
uniform vec4 iMouse;
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
const vec3 weight = vec3(0.325,  0.325, 0.325);

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    vec3 tex_sample = texture(iChannel0, uv).rgb;
    
    float greyscale = dot(tex_sample, weight);

    fragColor = vec4(greyscale, greyscale, greyscale,flixel_texture2D(bitmap, uv).a);
}