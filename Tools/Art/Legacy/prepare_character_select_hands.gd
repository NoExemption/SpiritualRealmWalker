extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	var source = Image.load_from_file(ToolPaths.option("--source", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png")))
	var dir = ToolPaths.option("--work-dir", ToolPaths.cache_dir("character-select-reconstruction")) + "/"
	source.get_region(Rect2i(2260,980,420,330)).save_png(dir+"viewer-left-hand-input.png")
	source.get_region(Rect2i(3120,990,420,330)).save_png(dir+"viewer-right-hand-input.png")
	quit(0)
