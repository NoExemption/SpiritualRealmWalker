extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize():
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()) or not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		push_error("Cannot load deployment pack")
		quit(1)
		return
	var texture=load("res://SpiritualRealmWalker/images/cards/dance_together.png") as Texture2D
	var source=Image.load_from_file(ToolPaths.project("Art/Cards/dance_together/dance-together.png"))
	if texture==null or source==null:
		push_error("Missing texture or source")
		quit(1)
		return
	var packed=texture.get_image()
	source.convert(Image.FORMAT_RGBA8)
	packed.convert(Image.FORMAT_RGBA8)
	if source.get_size()!=packed.get_size() or source.get_data()!=packed.get_data():
		push_error("Deployed image differs from confirmed second image")
		quit(1)
		return
	print("DANCE_TOGETHER_FINAL_IMAGE_DEPLOYED; size=",packed.get_size(),"; all_rgba_pixels_match=true")
	quit(0)