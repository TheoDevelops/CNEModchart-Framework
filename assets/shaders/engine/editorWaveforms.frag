#pragma header

// Used in charter by waveforms

const vec3 gradient1 = vec3(114.0/255.0, 81.0/255.0, 135.0/255.0);
const vec3 gradient2 = vec3(144.0/255.0, 80.0/255.0, 186.0/255.0);

const vec4 outlinecolor = vec4(0.1);
const vec3 lowdetailcol = vec3(0.0, 0.0, 1.0);

uniform vec2 textureRes;
uniform float pixelOffset;

uniform float playerPosition;

uniform sampler2D waveformTexture;
uniform ivec2 waveformSize;

uniform bool lowDetail;

float getAmplitude(vec2 pixel) {
	float pixelID = floor((pixel.y+pixelOffset)/3.0);

	// TODO: INVESTIGATE THE 1.+ AND WHY IT WORKS (SRSLY I GOT NO CLUE) -lunar
	vec2 wavePixel = vec2(mod(pixelID,waveformSize.x), 1.0+floor(pixelID/waveformSize.x));
	vec4 waveData = texture2D(waveformTexture, wavePixel / waveformSize);

	int id = int(mod(wavePixel.x, 3.0));
	if(id == 0) return waveData.r;
	if(id == 1) return waveData.g;
	if(id == 2) return waveData.b;
	return 0.0;
}

float getAmpWidth(float amplitude) {
	return (1.0-amplitude) * textureRes.x;
}

bool inWaveForm(vec2 pixel, float width) {
	float widthdiv2 = width/2.0;
	return pixel.x > widthdiv2 && pixel.x < textureRes.x-widthdiv2;
}

float getHightlight(float ampwidth) {
	float remapCoord = (ampwidth/textureRes.x)/2.0;
	float mappedCoord = map(openfl_TextureCoordv.x, remapCoord, 1.0-remapCoord, 0.0, 1.0);
	return 1.0-(abs(mappedCoord-0.5)*2.0);
}

void outlineWaveform(vec2 pixel, vec2 offset) {
	float amplitude = getAmplitude(pixel - offset);
	float ampwidth = (1.0-amplitude) * textureRes.x;

	if (!inWaveForm(pixel, ampwidth))
		gl_FragColor -= outlinecolor*mix(0.5, 0.8, amplitude);
}

void highDetailWaveform(vec2 pixel, float amplitude, float ampwidth) {
	vec3 gradientColor = mix(gradient1, gradient2, openfl_TextureCoordv.x);
	gradientColor *= pixel.y+pixelOffset>playerPosition ? 0.7 : 1.0;
	gradientColor = mix(gradientColor, gradientColor * vec3(1.8), map(getHightlight(amplitude), 0.0, 1.0, 0.5, 1.0));

	float ampwidthHighlight = getAmpWidth(amplitude/3.0);
	if (inWaveForm(pixel, ampwidthHighlight))
		gradientColor = mix(gradientColor, gradientColor * vec3(1.8), map(getHightlight(ampwidthHighlight), 0.0, 1.0, 0.5, 1.0));

	gl_FragColor = vec4(vec3(gradientColor * mix(0.5, 0.8, amplitude))*openfl_Alphav, openfl_Alphav);

	outlineWaveform(pixel, vec2(0.0, -1.0));
	outlineWaveform(pixel, vec2(0.0, 1.0));
}

void lowDetailWaveform(vec2 pixel, float amplitude, float ampwidth) {
	gl_FragColor = vec4(lowdetailcol * (pixel.y+pixelOffset>playerPosition ? 0.7 : 1.0), 1.0);
}

void main()
{
	vec2 pixel = openfl_TextureCoordv * textureRes;
	float amplitude = getAmplitude(pixel);
	float ampwidth = getAmpWidth(amplitude);

	gl_FragColor = vec4(0.0);
	if (!inWaveForm(pixel, ampwidth)) return;

	if (lowDetail) lowDetailWaveform(pixel, amplitude, ampwidth);
	else highDetailWaveform(pixel, amplitude, ampwidth);
}