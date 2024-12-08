#pragma header
// https://www.shadertoy.com/view/fsdGz4
// false paradise background for Schmovin' Mod Test by 4mbr0s3 2
// I couldn't find the exact shader in ZGameEditor so I thought it'd be fun to recreate it from scratch 
// Having After Effects experience really helps with this kind of shader lol

// Fractal Brownian Motion code ripped off this page in the Book of Shaders: 
// https://thebookofshaders.com/13/

// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com

// Start ripped code

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 3
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st + iTime);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

// End ripped code

float topologicalLines(vec2 uv) {
    float noise = fbm(uv);
    float ampMap = (sin(noise * 60. + iTime) + 1.) / 2.;
    return ampMap;
}
float circLines(vec2 uv) {
    vec2 diff = uv - vec2(0.5, 0.5) * iResolution.xy / iResolution.y * 5.;
    float dist = sqrt(dot(diff, diff)) * (5. + sin(iTime));
    return (sin(dist - iTime * 5.) + 1.) / 2.;
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;

    float lines = topologicalLines(uv * iResolution.xy / iResolution.y * 5.);
    float lines2 = circLines(uv * iResolution.xy / iResolution.y * 5.);

    vec4 bgComposite = vec4(69., 153., 165., 255.) / 255.;
    vec4 linesComposite = vec4(234., 223., 172., 255.) / 255.;
    
    vec4 final = mix(mix(linesComposite, bgComposite, lines), bgComposite, lines2);
    // Output to screen
    gl_FragColor = vec4(final);
}