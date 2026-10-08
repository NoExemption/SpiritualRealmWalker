extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	var texture = load("res://images/atlases/ui_atlas.sprites/card/card_frame_attack_s.tres") as Texture2D
	if texture == null:
		quit(1)
		return
	var atlas = texture as AtlasTexture
	var picture = atlas.atlas.get_image()
	if picture.is_compressed():
		picture.decompress()
	picture = picture.get_region(atlas.region)
	print("frame_size=", picture.get_size())
	picture.save_png(ToolPaths.cache_dir().path_join("original_frame_reference.png"))
	quit(0)
