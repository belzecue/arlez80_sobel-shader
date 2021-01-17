/*
	ガウシアンフィルタとSobel シェーダー by あるる（きのもと 結衣）
	Sobel with Gaussian filter Shader by @arlez80

	MIT License
*/

shader_type canvas_item;
render_mode unshaded, blend_disabled;

const vec3 MONOCHROME_SCALE = vec3( 0.298912, 0.586611, 0.114478 );

float gaussian5x5( sampler2D tex, vec2 uv, vec2 pix_size )
{
	float p = 0.0;
	float coef[25] = { 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625, 0.015625, 0.0625, 0.09375, 0.0625, 0.015625, 0.0234375, 0.09375, 0.140625, 0.09375, 0.0234375, 0.015625, 0.0625, 0.09375, 0.0625, 0.015625, 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625 };

	for( int y=-2; y<=2; y++ ) {
		for( int x=-2; x<=2; x ++ ) {
			p += dot( MONOCHROME_SCALE, texture( tex, uv + vec2( float( x ), float( y ) ) * pix_size ).rgb ) * coef[(y+2)*5 + (x+2)];
		}
	}

	return p;
}

void fragment( )
{
	float pix[9];	// 3 x 3

	// ガウシアンフィルタ
	for( int y=0; y<3; y ++ ) {
		for( int x=0; x<3; x ++ ) {
			pix[y*3+x] = gaussian5x5( SCREEN_TEXTURE, SCREEN_UV + vec2( float( x-1 ), float( y-1 ) ) * SCREEN_PIXEL_SIZE, SCREEN_PIXEL_SIZE );
		}
	}

	// Sobelフィルタ
	vec2 sobel_src = vec2(
		(
			pix[0] * -1.0
		+	pix[3] * -2.0
		+	pix[6] * -1.0
		+	pix[2] * 1.0
		+	pix[5] * 2.0
		+	pix[8] * 1.0
		)
	,	(
			pix[0] * -1.0
		+	pix[1] * -2.0
		+	pix[2] * -1.0
		+	pix[6] * 1.0
		+	pix[7] * 2.0
		+	pix[8] * 1.0
		)
	);
	float sobel = clamp( sqrt( dot( sobel_src, sobel_src ) ), 0.0, 1.0 );

	COLOR = vec4( sobel, sobel, sobel, 1.0 );
}
