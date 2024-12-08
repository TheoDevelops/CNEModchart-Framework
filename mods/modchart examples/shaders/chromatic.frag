#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
uniform sampler2D iChannel1;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
//****MAKE SURE TO remove the parameters from mainImage.
//SHADERTOY PORT FIX

void mainImage()
{
    float aberrationAmount = 0.05 + 0.5 * abs(iMouse.y / iResolution.y / 8.0);

    vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 distFromCenter = uv -  0.8;

    // stronger aberration near the edges by raising to power 3
    vec2 aberrated = aberrationAmount * pow(distFromCenter, vec2(3.0, 3.0));
    
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    
    for (int i = 1; i <= 8; i++)
    {
        // the sum of the weights will be ~1
        float weight = 1.0 / pow(2.0, float(i));
        fragColor.r += texture(iChannel0, uv - float(i) * aberrated).r * weight;
        fragColor.b += texture(iChannel0, uv + float(i) * aberrated).b * weight;
    }
    
    fragColor.g = texture(iChannel0, uv).g * 0.9961; // 0.9961 = weight(1)+weight(2)+...+weight(8);
}
