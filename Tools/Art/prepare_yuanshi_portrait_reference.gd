extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	var source = Image.load_from_file(ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png"))
	var result = source.get_region(Rect2i(2630,310,900,1000))
	var err = result.save_png(ToolPaths.cache_dir().path_join("yuanshi-portrait-identity-reference.png"))
	print("IDENTITY_REFERENCE size=",result.get_size()," error=",err)
	quit(0 if err==OK else 1)
