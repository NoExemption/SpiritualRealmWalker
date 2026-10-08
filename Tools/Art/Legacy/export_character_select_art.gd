extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var source_path = ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-v2.png")
	var output_path = ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-v2-3840x2400.png")
	var art = Image.load_from_file(source_path)
	if art == null:
		push_error("Could not load source illustration")
		quit(1)
		return
	print("SOURCE ", art.get_size())
	# Preserve the native aspect ratio, then trim only one output pixel per side.
	art.resize(3840, 2402, Image.INTERPOLATE_LANCZOS)
	var prepared = art.get_region(Rect2i(0, 1, 3840, 2400))
	var result = prepared.save_png(output_path)
	if result != OK:
		push_error("Could not save prepared illustration: " + str(result))
		quit(1)
		return
	var checked = Image.load_from_file(output_path)
	if checked == null or checked.get_size() != Vector2i(3840, 2400):
		push_error("Prepared dimensions did not match")
		quit(1)
		return
	print("OUTPUT ", checked.get_size(), " opaque=", not checked.detect_alpha())
	quit(0)
