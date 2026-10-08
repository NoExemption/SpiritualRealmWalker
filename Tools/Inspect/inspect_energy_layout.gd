extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	var font = load("res://themes/kreon_bold_shared.tres") as Font
	if font == null:
		quit(1)
		return
	var text_server = TextServerManager.get_primary_interface()
	print("font_class=", font.get_class(), " embolden=", font.get("variation_embolden"), " base_font=", font.get("base_font"))
	var bold_font = font.duplicate() as FontVariation
	var source_file = bold_font.base_font as FontFile
	print("source_msdf=", source_file.multichannel_signed_distance_field)
	var raster_file = source_file.duplicate() as FontFile
	raster_file.multichannel_signed_distance_field = false
	bold_font.base_font = raster_file
	bold_font.variation_embolden += 0.65
	print("emboldened_copy=", bold_font.variation_embolden, " original=", font.get("variation_embolden"), " digits_at_26=", bold_font.get_string_size("0123X", HORIZONTAL_ALIGNMENT_LEFT, -1, 26))
	print("copy_msdf=", raster_file.multichannel_signed_distance_field, " source_msdf_after=", source_file.multichannel_signed_distance_field)
	var font_rid = font.get_rids()[0]
	for value in ["0", "1", "2", "3", "X"]:
		var glyph = text_server.font_get_glyph_index(font_rid, 32, value.unicode_at(0), 0)
		var glyph_size = text_server.font_get_glyph_size(font_rid, Vector2i(32, 0), glyph)
		var glyph_offset = text_server.font_get_glyph_offset(font_rid, Vector2i(32, 0), glyph)
		var relative_center_y = -26 + (56 - font.get_height(32)) / 2.0 + font.get_ascent(32) + glyph_offset.y + glyph_size.y / 2.0
		print(value, " ascent=", font.get_ascent(32), " height=", font.get_height(32), " glyph=", glyph_size, " offset=", glyph_offset, " center_below_icon=", relative_center_y)
	quit(0)
