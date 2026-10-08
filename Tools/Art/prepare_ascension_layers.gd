extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var base = Image.load_from_file(ToolPaths.option("--source", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png")))
	var fill = Image.load_from_file(ToolPaths.option("--cleanplate", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension/character-select-cloud-cleanplate-v1.png")))
	var coverage_data = FileAccess.get_file_as_bytes(ToolPaths.cache_dir("ascension").path_join("ascension-coverage.r8"))
	var removal_data = FileAccess.get_file_as_bytes(ToolPaths.cache_dir("ascension").path_join("ascension-removal.r8"))
	if base == null or fill == null or base.get_size() != Vector2i(3840, 2400):
		push_error("Missing background/cleanplate or background dimensions differ")
		quit(1)
		return
	if coverage_data.size() != 3840 * 2400 or removal_data.size() != 3840 * 2400:
		push_error("Missing coverage/removal data; run analyze_ascension_matte.py first")
		quit(1)
		return
	var coverage = Image.create_from_data(3840, 2400, false, Image.FORMAT_R8, coverage_data)
	fill.resize(3840, 2400, Image.INTERPOLATE_LANCZOS)
	var matte_bytes := PackedByteArray()
	matte_bytes.resize(3840 * 2400 * 4)
	for i in range(coverage_data.size()):
		matte_bytes[i * 4] = coverage_data[i]
		matte_bytes[i * 4 + 1] = removal_data[i]
		matte_bytes[i * 4 + 2] = coverage_data[i]
		matte_bytes[i * 4 + 3] = 255
	var matte = Image.create_from_data(3840, 2400, false, Image.FORMAT_RGBA8, matte_bytes)
	# Complete source canvas coordinates are retained for every animation plane.
	var output := ToolPaths.output_dir(ToolPaths.cache_dir("ascension/layers"))
	if fill.save_png(output.path_join("yuanshi_tianzun_cloud_fill.png")) != OK or matte.save_png(output.path_join("yuanshi_tianzun_subject_mask.png")) != OK:
		push_error("Could not save prepared layers")
		quit(1)
		return
	print("ASCENSION_LAYERS original_figure_rgb_retained=true fill_size=", fill.get_size(), " matte_size=", coverage.get_size())
	quit(0)
