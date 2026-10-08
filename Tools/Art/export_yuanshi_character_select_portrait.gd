extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	var root = ToolPaths.project("Art/Characters/yuanshi_tianzun/portrait") + "/"
	var image = Image.load_from_file(ToolPaths.option("--source", root+"character-select-portrait.png"))
	if image == null or image.is_empty():
		push_error("Portrait master image is missing")
		quit(1)
		return
	var native = image.get_size()
	var ratio = maxf(132.0/native.x,195.0/native.y)
	var scaled_size = Vector2i(ceili(native.x*ratio),ceili(native.y*ratio))
	image.resize(scaled_size.x,scaled_size.y,Image.INTERPOLATE_LANCZOS)
	var offset = (scaled_size-Vector2i(132,195))/2
	var icon = image.get_region(Rect2i(offset,Vector2i(132,195)))
	var path = ToolPaths.output_dir(root).path_join("character-select-portrait-icon.png")
	var result = icon.save_png(path)
	var reloaded = Image.load_from_file(path)
	var small = icon.duplicate()
	small.resize(88,130,Image.INTERPOLATE_LANCZOS)
	small.save_png(ToolPaths.cache_dir().path_join("yuanshi-character-select-portrait-88x130.png"))
	print("PORTRAIT_EXPORT native=",native," scaled=",scaled_size," crop_offset=",offset," icon=",reloaded.get_size()," alpha=",reloaded.detect_alpha()," save=",result)
	quit(0 if result==OK and reloaded.get_size()==Vector2i(132,195) else 1)
