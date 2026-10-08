extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var folder = ToolPaths.output_dir(ToolPaths.project("Art/Relics/character_card"))
	var source = Image.load_from_file(ToolPaths.option("--source", folder.path_join("character-card.png")))
	if source == null or source.is_empty():
		quit(1)
		return
	source.convert(Image.FORMAT_RGBA8)
	print("SOURCE size=", source.get_size(), " alpha=", source.detect_alpha(), " used=", source.get_used_rect())
	for size in [256, 85]:
		var img = source.duplicate()
		img.resize(size, size, Image.INTERPOLATE_LANCZOS)
		var path = folder.path_join("character-card-big.png" if size == 256 else "character-card-icon.png")
		if img.save_png(path) != OK:
			quit(1)
			return
		var check = Image.load_from_file(path)
		if check.get_size() != Vector2i(size, size) or check.detect_alpha() == Image.ALPHA_NONE:
			quit(1)
			return
		print("EXPORTED ", path, " size=", check.get_size(), " alpha=", check.detect_alpha(), " used=", check.get_used_rect())
	quit(0)
