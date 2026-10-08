extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	var candidate = Image.load_from_file(ToolPaths.option("--source", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png")))
	var source = Image.load_from_file(ToolPaths.option("--source", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png")))
	var dir = ToolPaths.option("--work-dir", ToolPaths.cache_dir("character-select-reconstruction")) + "/"
	candidate.get_region(Rect2i(2730,1650,500,550)).save_png(dir+"feet-check.png")
	candidate.get_region(Rect2i(2500,750,370,520)).save_png(dir+"vertical-join-check.png")
	var rect = Rect2i(2780,420,470,530)
	var comparison = Image.create(940,530,false,Image.FORMAT_RGB8)
	comparison.blit_rect(source,rect,Vector2i.ZERO)
	comparison.blit_rect(candidate,rect,Vector2i(470,0))
	comparison.save_png(dir+"face-comparison-original-left.png")
	print("INSPECT size=",candidate.get_size()," alpha=",candidate.detect_alpha())
	quit(0)
