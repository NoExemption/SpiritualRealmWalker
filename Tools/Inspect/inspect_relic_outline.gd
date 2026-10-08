extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var tex = load("res://images/atlases/relic_outline_atlas.sprites/akabeko.tres") as AtlasTexture
	var img = tex.atlas.get_image()
	if img.is_compressed():
		img.decompress()
	img = img.get_region(tex.region)
	print("OUTLINE ", img.get_size(), " center=", img.get_pixel(42, 38))
	img.save_png(ToolPaths.cache_dir().path_join("native-relic-outline.png"))
	quit()
