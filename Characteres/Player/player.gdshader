shader_type canvas_item;
//rgb(91, 210, 140)
uniform vec4 baseColor = vec4(0.35, 0.82, 0.54, 0.0);

void fragment() {
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR.rgba = vec4(baseColor.r, baseColor.g, baseColor.b, textureColor.a);
}
