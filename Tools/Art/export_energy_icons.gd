extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var source = Image.load_from_file(ToolPaths.project("Art/UI/energy_icons/energy_big.png"))
	if source == null or source.get_size() != Vector2i(74, 74):
		push_error("Expected a 74x74 energy_big.png")
		quit(1)
		return
	source.convert(Image.FORMAT_RGBA8)
	var small = source.duplicate()
	small.resize(24, 24, Image.INTERPOLATE_LANCZOS)
	var outputs = [
		[source, ToolPaths.project("SpiritualRealmWalker/images/ui/energy_big.png")],
		[small, ToolPaths.project("Art/UI/energy_icons/energy_text.png")],
		[small, ToolPaths.project("SpiritualRealmWalker/images/ui/energy_text.png")]
	]
	for output in outputs:
		if output[0].save_png(output[1]) != OK:
			quit(1)
			return
		print(output[1], " size=", output[0].get_size())
	quit(0)
