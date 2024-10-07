shader_type canvas_item;

uniform bool is_object_centered; // Note that this needs to match with the sprite's centered property
uniform bool is_round;
uniform float circle_radius = 1;
uniform float outline_thickness:hint_range(0.0, 0.1) = 0.01;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

varying flat vec2 center_pos;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
void vertex() {
    center_pos = is_object_centered ? vec2(0.0) : 0.5 / TEXTURE_PIXEL_SIZE; 
    // From local space texel coordinates to screen space pixel coordinates
    center_pos = (MODEL_MATRIX * vec4(center_pos, 0.0, 1.0)).xy;
}

void fragment() {
	if(texture(TEXTURE, UV).a <= 0.05)
	{
		 COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	}
	else
	{
		vec2 screen_resolution = 1.0 / SCREEN_PIXEL_SIZE;
	    vec2 uv_distance = vec2(0.5) - UV;
	    vec2 pixel_distance = center_pos - FRAGCOORD.xy;
	    vec2 obj_size = (pixel_distance / uv_distance / (distance(UV, vec2(0.5, 0.5)) * 8.0 + 1.0)) * 2.0;
	    vec2 ratio = obj_size / screen_resolution;
	    vec2 local_mapped_uv = mix(UV, vec2(0.5), 0.5);
	    vec2 difference = local_mapped_uv - UV;
	    vec2 global_mapped_uv = SCREEN_UV + difference * ratio;
	    COLOR = texelFetch(SCREEN_TEXTURE, ivec2(int(global_mapped_uv.x * screen_resolution.x), int((global_mapped_uv.y) * screen_resolution.y)), 0);
		COLOR = vec4(texture(TEXTURE, UV).r * texture(TEXTURE, UV).a + COLOR.r * (1.0 - texture(TEXTURE, UV).a),
					 texture(TEXTURE, UV).g * texture(TEXTURE, UV).a + COLOR.g * (1.0 - texture(TEXTURE, UV).a),
					 texture(TEXTURE, UV).b * texture(TEXTURE, UV).a + COLOR.b * (1.0 - texture(TEXTURE, UV).a),  
					 texture(TEXTURE, UV).a + COLOR.a);
	}
}
