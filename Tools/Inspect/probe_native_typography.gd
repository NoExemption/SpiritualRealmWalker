extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	for path in ["res://themes/fonts/zhs/noto_sans_mono_cjksc_regular_shared.tres", "res://themes/fonts/zhs/source_han_serif_sc_bold_shared.tres", "res://themes/fonts/zhs/source_han_serif_sc_medium_shared.tres", "res://fonts/zhs/NotoSansMonoCJKsc-Regular.otf.import"]:
		print("FILE ", path, "\n", FileAccess.get_file_as_string(path))
	var font = load("res://themes/fonts/zhs/noto_sans_mono_cjksc_regular_shared.tres") as FontVariation
	print("Native font family ", font.get_font_name(), " style ", font.get_font_style_name(), " scale ", font.variation_embolden)
	var base = font.base_font as FontFile
	print("Native font MSDF ", base.multichannel_signed_distance_field, " pixel range ", base.msdf_pixel_range, " msdf size ", base.msdf_size)
	quit(0)
